//
//  Category.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 12/12/2024.
//

import Foundation

struct Category: Decodable {
    let display_name: String
    let list_name_encoded: String

    var id: String { return list_name_encoded }
    var name: String { return display_name }
}

struct CategoriesResponse: Decodable {
    let results: [Category]
}
