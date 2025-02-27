//
//  MockCategoriesService.swift
//  NYT Bestsellers-SwiftUITests
//
//  Created by Sylvan Ash on 27/02/2025.
//

import Foundation
import Combine
@testable import NYT_Bestsellers_SwiftUI

final class MockCategoriesService: CategoriesServiceProtocol {
    var response: CategoriesResponse = CategoriesResponse(results: [])
    var shouldFail = false

    func fetchCategories() -> AnyPublisher<CategoriesResponse, Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "MockError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
                .eraseToAnyPublisher()
        }

        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchCategories() async -> Result<CategoriesResponse, Error> {
        fatalError("Not needed for anypublisher testing")
    }
}
