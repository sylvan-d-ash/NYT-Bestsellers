//
//  APIService.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 12/12/2024.
//

import Foundation
import Combine

protocol CategoriesListService {
    func fetchCategories() -> AnyPublisher<[Category], Error>
}

final class APIService: CategoriesListService {
    private let baseUrl = ""

    func fetchCategories() -> AnyPublisher<[Category], Error> {
        guard let url = URL(string: baseUrl + "") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Category].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
