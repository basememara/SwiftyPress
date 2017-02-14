//
//  TermService.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/13/16.
//
//

import Foundation
import Alamofire
import RealmSwift
import ZamzamKit

public struct TermService: Serviceable {

}

extension TermService {

    public func get(complete: @escaping ([Termable]) -> Void) {
        guard let realm = try? Realm() else { return complete([]) }
        complete(realm.objects(Term.self).map { $0 })
    }

    public func get(from taxonomy: TaxonomyType, complete: @escaping ([Termable]) -> Void) {
        guard let realm = try? Realm() else { return complete([]) }
        complete(realm.objects(Term.self)
            .filter("taxonomy = %@ && count > 0", taxonomy.rawValue)
            .sorted(byKeyPath: "count", ascending: false)
            .map { $0 }
        )
    }
    
    /**
     Get term by url by extracting slug.

     - parameter url: URL of the term.

     - returns: Term matching the extracted slug from the URL.
     */
    public func get(_ url: URL) -> Term? {
        guard let realm = try? Realm(), let slug = url.pathComponents.get(2),
            url.pathComponents.get(1) == "category" || url.pathComponents.get(1) == "tag"
                else { return nil }
        
        return realm.objects(Term.self).filter("slug == '\(slug)'").first
    }
    
    public func name(for id: Int) -> String? {
        guard let realm = try? Realm() else { return nil }
        return realm.object(ofType: Term.self, forPrimaryKey: id)?.name
    }
    
    public func taxonomy(for id: Int) -> TaxonomyType {
        guard let realm = try? Realm(),
            let taxonomy = realm.object(ofType: Term.self, forPrimaryKey: id)?.taxonomy,
            let type = TaxonomyType(rawValue: taxonomy)
                else { return .category }
        
        return type
    }
}

extension TermService {

    public func getFromRemote(for taxonomy: TaxonomyType, id: Int, complete: @escaping (Termable) -> Void) {
        Alamofire.request(TermRouter.readTerm(taxonomy, id))
            .responseJASON { response in
                guard let json = response.result.value, response.result.isSuccess else { return }
                complete(Term(json: json))
        }
    }
    
    @discardableResult
    public func updateFromRemote(for taxonomy: TaxonomyType, orderBy: String = "count", ascending: Bool = false, number: Int = 0, complete: ((ZamzamKit.Result<[Termable]>) -> Void)? = nil) -> SessionManager {
        let manager = Alamofire.SessionManager.default
        
        manager.request(TermRouter.readTerms(taxonomy, orderBy, ascending, number))
            .responseJASON { response in
                guard response.result.isSuccess,
                    let realm = try? Realm(),
                    let json = response.result.value else {
                        complete?(.failure(response.result.error ?? PressError.general))
                        return Log(debug: "Could not retrieve terms from remote server: \(response.debugDescription)")
                    }
                
                guard !json.arrayValue.isEmpty else { complete?(.success([])); return }
                
                // Parse JSON to array
                let results = json.map(Term.init)
                
                // Persist to local storage if applicable
                if !results.isEmpty {
                    do {
                        try realm.write { realm.add(List(results), update: true) }
                        Log(debug: "Terms updated from remote server: \(results.count) items.")
                    } catch {
                        complete?(.failure(PressError.databaseFail))
                        return Log(error: "Could not persist the terms: \(error).")
                    }
                }
                
                complete?(.success(results))
            }
        
        return manager
    }
}
