//
//  TagsDataViewModels.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

public struct TermsDataViewModel: Identifiable, Equatable {
    public let id: Int
    public let name: String
    public let count: String
    public let taxonomy: Taxonomy
    
    public init(id: Int, name: String, count: String, taxonomy: Taxonomy) {
        self.id = id
        self.name = name
        self.count = count
        self.taxonomy = taxonomy
    }
}
