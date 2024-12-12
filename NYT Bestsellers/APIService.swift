//
//  APIService.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 12/12/2024.
//

import Foundation
import Combine

protocol CategoriesListService {
    func fetchCategories() -> AnyPublisher<CategoriesResponse, Error>
}

final class APIService: CategoriesListService {
    private let baseUrl = "https://api.nytimes.com/svc/books/v3"

    static var apiKey: String {
        guard let key = Bundle.main.infoDictionary?["API_KEY"] as? String else {
            fatalError("Missing API Key!")
        }
        return key
    }

    func fetchCategories() -> AnyPublisher<CategoriesResponse, Error> {
        guard let url = URL(string: baseUrl + "/lists/names.json" + "?api-key=\(Self.apiKey)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: CategoriesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
