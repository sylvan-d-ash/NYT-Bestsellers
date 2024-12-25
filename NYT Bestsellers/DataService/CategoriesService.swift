//
//  CategoriesService.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 26/12/2024.
//

import Foundation
import Combine

enum CategoryEndpoint: APIEndpoint {
    case getCategories

    var path: String { return "/lists/names.json" }

    var parameters: [String : Any]? { return nil }
}

protocol CategoriesServiceProtocol {
    func fetchCategories() -> AnyPublisher<CategoriesResponse, Error>
}

final class CategoriesService: CategoriesServiceProtocol {
    let apiClient: APIClient

    init(apiClient: APIClient = URLSessionAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchCategories() -> AnyPublisher<CategoriesResponse, Error> {
        let endpoint = CategoryEndpoint.getCategories
        return apiClient.request(endpoint)
    }
}
