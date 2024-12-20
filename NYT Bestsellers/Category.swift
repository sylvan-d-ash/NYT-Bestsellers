//
//  Category.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 12/12/2024.
//

import Foundation

struct Category: Decodable {
    let id: String
    let name: String

    private enum CodingKeys: String, CodingKey {
        case id = "list_name_encoded"
        case name = "display_name"
    }
}

struct CategoriesResponse: Decodable {
    let results: [Category]
}
