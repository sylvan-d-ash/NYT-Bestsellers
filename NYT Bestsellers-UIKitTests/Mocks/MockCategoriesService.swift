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
    var result: Result<CategoriesResponse, Error>?

    func fetchCategories() async -> Result<CategoriesResponse, Error> {
        return result ?? .failure(NSError(domain: "MockError", code: -1, userInfo: nil))
    }

    func fetchCategories() -> AnyPublisher<CategoriesResponse, Error> {
        fatalError("Not needed for async testing")
    }
}
