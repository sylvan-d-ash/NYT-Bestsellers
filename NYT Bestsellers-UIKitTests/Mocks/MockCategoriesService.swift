//
//  MockCategoriesService.swift
//  NYT Bestsellers-UIKitTests
//
//  Created by Sylvan Ash on 24/02/2025.
//

import Foundation
import Combine
@testable import NYT_Bestsellers_UIKit

final class MockCategoriesService: CategoriesServiceProtocol {
    var shouldReturnError = false
    var mockCategories: [NYT_Bestsellers_UIKit.Category] = []

    func fetchCategories() -> AnyPublisher<CategoriesResponse, Error> {
        if shouldReturnError {
            return Fail(error: NSError(domain: "TestError", code: 500, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
                .eraseToAnyPublisher()
        } else {
            let response = CategoriesResponse(results: mockCategories)
            return Just(response)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}
