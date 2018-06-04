//
//  TaxonomyStoreInterfaces.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

import ZamzamKit

public protocol TaxonomyStore {
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void)
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void)
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void)
    func search(with request: TaxonomyModels.SearchRequest, completion: @escaping (Result<[TermType], DataError>) -> Void)
}

public protocol TaxonomyWorkerType: TaxonomyStore {

}
