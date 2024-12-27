//
//  BooksService.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 26/12/2024.
//

import Foundation
import Combine

enum BookEndpoint: APIEndpoint {
    case getBooks(forCategory: String)

    var path: String {
        switch self {
        case .getBooks(let category): return "/lists/current/" + category
        }
    }

    var parameters: [String : Any]? { return nil }
}

protocol BooksServiceProtocol {
    func fetchBooks(for category: String) -> AnyPublisher<BooksResponse, Error>
    func fetchBooks(for category: String) async -> Result<BooksResponse, Error>
}

final class BooksService: BooksServiceProtocol {
    let apiClient: APIClient

    init(apiClient: APIClient = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchBooks(for category: String) -> AnyPublisher<BooksResponse, Error> {
        let endpoint = BookEndpoint.getBooks(forCategory: category)
        return apiClient.request(endpoint)
    }

    func fetchBooks(for category: String) async -> Result<BooksResponse, Error> {
        let endpoint = BookEndpoint.getBooks(forCategory: category)
        return await apiClient.request(endpoint)
    }
}
