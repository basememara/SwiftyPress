//
//  TaxonomyMemoryStore.swift
//  SwiftyPress
//
//  Created by Basem Emara on 2018-06-04.
//

@testable import SwiftyPress
import ZamzamKit

public struct TaxonomyMemoryStore: TaxonomyStore {
    
}

public extension TaxonomyMemoryStore {
    
    func fetch(completion: @escaping (Result<[TermType], DataError>) -> Void) {
        completion(.success([
            Term(
                id: 1,
                parentID: 0,
                slug: "category-1",
                name: "Category 1",
                taxonomy: .category,
                count: 1
            ),
            Term(
                id: 2,
                parentID: 0,
                slug: "category-2",
                name: "Category 2",
                taxonomy: .category,
                count: 1
            ),
            Term(
                id: 3,
                parentID: 0,
                slug: "category-3",
                name: "Category 3",
                taxonomy: .category,
                count: 1
            ),
            Term(
                id: 4,
                parentID: 0,
                slug: "category-4",
                name: "Category 4",
                taxonomy: .category,
                count: 1
            ),
            Term(
                id: 5,
                parentID: 0,
                slug: "category-5",
                name: "Category 5",
                taxonomy: .category,
                count: 1
            ),
            Term(
                id: 6,
                parentID: 0,
                slug: "category-6",
                name: "Category 6",
                taxonomy: .category,
                count: 1
            ),
            Term(
                id: 7,
                parentID: 0,
                slug: "category-7",
                name: "Category 7",
                taxonomy: .category,
                count: 1
            ),
            Term(
                id: 8,
                parentID: 0,
                slug: "category-8",
                name: "Category 8",
                taxonomy: .category,
                count: 1
            ),
            Term(
                id: 9,
                parentID: 0,
                slug: "category-9",
                name: "Category 9",
                taxonomy: .category,
                count: 1
            ),
            Term(
                id: 10,
                parentID: 0,
                slug: "tag-10",
                name: "Tag 10",
                taxonomy: .tag,
                count: 1
            ),
            Term(
                id: 11,
                parentID: 0,
                slug: "tag-11",
                name: "Tag 11",
                taxonomy: .tag,
                count: 1
            ),
            Term(
                id: 12,
                parentID: 0,
                slug: "tag-12",
                name: "Tag 12",
                taxonomy: .tag,
                count: 1
            ),
            Term(
                id: 20,
                parentID: 0,
                slug: "tag-20",
                name: "Tag 20",
                taxonomy: .tag,
                count: 1
            ),
            Term(
                id: 21,
                parentID: 0,
                slug: "tag-21",
                name: "Tag 21",
                taxonomy: .tag,
                count: 1
            ),
            Term(
                id: 22,
                parentID: 0,
                slug: "tag-22",
                name: "Tag 22",
                taxonomy: .tag,
                count: 1
            ),
            Term(
                id: 30,
                parentID: 0,
                slug: "tag-30",
                name: "Tag 30",
                taxonomy: .tag,
                count: 1
            ),
            Term(
                id: 31,
                parentID: 0,
                slug: "tag-31",
                name: "Tag 31",
                taxonomy: .tag,
                count: 1
            ),
            Term(
                id: 32,
                parentID: 0,
                slug: "tag-32",
                name: "Tag 32",
                taxonomy: .tag,
                count: 1
            )
        ]))
    }
}

public extension TaxonomyMemoryStore {
    
    func fetch(id: Int, completion: @escaping (Result<TermType, DataError>) -> Void) {
        fetch {
            guard let value = $0.value?.first(where: { $0.id == id }), $0.isSuccess else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
    
    func fetch(ids: Set<Int>, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            completion(.success(value.filter { ids.contains($0.id) }))
        }
    }
    
    func fetch(slug: String, completion: @escaping (Result<TermType, DataError>) -> Void) {
        fetch {
            guard let value = $0.value?.first(where: { $0.slug == slug }), $0.isSuccess else {
                return completion(.failure(.nonExistent))
            }
            
            completion(.success(value))
        }
    }
    
    func fetch(by taxonomy: Taxonomy, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            completion(.success(value.filter { $0.taxonomy == taxonomy }))
        }
    }
    
    func search(with request: TaxonomyModels.SearchRequest, completion: @escaping (Result<[TermType], DataError>) -> Void) {
        fetch {
            guard let value = $0.value, $0.isSuccess else { return completion($0) }
            
            var result = value.filter {
                $0.name.range(of: request.query, options: .caseInsensitive) != nil
            }
            
            if let taxonomy = request.scope {
                result = result.filter { $0.taxonomy == taxonomy }
            }
            
            completion(.success(result))
        }
    }
}
