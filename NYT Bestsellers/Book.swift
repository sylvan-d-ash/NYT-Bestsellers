//
//  Book.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 20/12/2024.
//

import Foundation

struct Book: Decodable {
    let title: String
    let author: String
    let publisher: String
    let rank: Int
    let previousRank: Int

    private enum CodingKeys: String, CodingKey {
        case title, author, publisher, rank
        case previousRank = "rank_last_week"
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
