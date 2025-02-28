//
//  MockBooksService.swift
//  NYT Bestsellers-UIKitTests
//
//  Created by Sylvan Ash on 28/02/2025.
//

import Foundation
import Combine
@testable import NYT_Bestsellers_UIKit

final class MockBooksService: BooksServiceProtocol {
    var result: Result<BooksResponse, Error>?

    func fetchBooks(for category: String) async -> Result<BooksResponse, Error> {
        return result ?? .failure(NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
    }

    func fetchBooks(for category: String) -> AnyPublisher<BooksResponse, Error> {
        fatalError("Not needed for async testing")
    }
}
