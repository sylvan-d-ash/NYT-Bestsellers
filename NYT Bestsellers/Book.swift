//
//  Book.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 20/12/2024.
//

import Foundation

struct Book: Decodable {
    let rank: Int
    let title: String
    let author: String
    let publisher: String
    let previousRank: Int
    let isbn13: String

    private enum CodingKeys: String, CodingKey {
        case title, author, publisher, rank
        case previousRank = "rank_last_week"
        case isbn13 = "primary_isbn13"
    }
}

struct BooksResponse: Decodable {
    struct Results: Decodable {
        let books: [Book]
    }

    let count: Int
    let results: Results

    private enum CodingKeys: String, CodingKey {
        case results
        case count = "num_results"
    }
}
