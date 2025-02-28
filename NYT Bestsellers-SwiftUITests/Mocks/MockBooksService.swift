//
//  MockBooksService.swift
//  NYT Bestsellers-SwiftUITests
//
//  Created by Sylvan Ash on 28/02/2025.
//

import Foundation
import Combine
@testable import NYT_Bestsellers_SwiftUI

final class MockBooksService: BooksServiceProtocol {
    var response: BooksResponse = BooksResponse(count: 0, results: BooksResponse.Results(books: []))
    var shouldFail = false

    func fetchBooks(for category: String) -> AnyPublisher<BooksResponse, Error> {
        if shouldFail {
            return Fail(error: NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
                .eraseToAnyPublisher()
        }

        return Just(response)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func fetchBooks(for category: String) async -> Result<BooksResponse, Error> {
        fatalError("Not needed for AnyPublisher testing")
    }
}
