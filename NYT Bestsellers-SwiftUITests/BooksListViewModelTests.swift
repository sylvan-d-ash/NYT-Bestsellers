//
//  BooksListViewModelTests.swift
//  NYT Bestsellers-SwiftUITests
//
//  Created by Sylvan Ash on 28/02/2025.
//

import XCTest
import Combine
@testable import NYT_Bestsellers_SwiftUI

final class BooksListViewModelTests: XCTestCase {
    private var viewModel: BooksListViewModel!
    private var service: MockBooksService!
    private var category: NYT_Bestsellers_SwiftUI.Category!
    private var cancellables: Set<AnyCancellable> = []

//    @MainActor
    override func setUp() {
        super.setUp()
        service = MockBooksService()
        category = NYT_Bestsellers_SwiftUI.Category(id: "fiction", name: "Fiction")
        viewModel = BooksListViewModel(category: category, service: service)
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        category = nil
        cancellables.removeAll()
        super.tearDown()
    }

    func testInitialState() {
        XCTAssertNil(viewModel.rank1Book)
        XCTAssertTrue(viewModel.books.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testIsLoadingState() {
        let expectationStart = expectation(description: "isLoading should be true when loading starts")
        let expectationEnd = expectation(description: "isLoading should be false when laoding ends")

        var observedStates: [Bool] = []

        viewModel.$isLoading
            .dropFirst() // Ignore initial value
            .sink { isLoading in
                observedStates.append(isLoading)

                if isLoading {
                    expectationStart.fulfill()
                } else {
                    expectationEnd.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadBooks()
        wait(for: [expectationStart, expectationEnd], timeout: 1)

        XCTAssertEqual(observedStates, [true, false], "isLoading should transition from true to false")
    }

    func testLoadBooks_Success() {
        // given
        let books = [
            Book(rank: 1, title: "Book 1", author: "Test Author", publisher: "", previousRank: 1, isbn13: "abcd1234", description: "", imageUrl: ""),
            Book(rank: 2, title: "Book 2", author: "Test Author 2", publisher: "", previousRank: 2, isbn13: "bcde2345", description: "", imageUrl: ""),
            Book(rank: 3, title: "Book 3", author: "Test Author 3", publisher: "", previousRank: 5, isbn13: "cdef3456", description: "", imageUrl: ""),
        ]
        let response = BooksResponse(count: books.count, results: BooksResponse.Results(books: books))
        service.response = response

        let expectation = expectation(description: "Books loaded successfully")

        // when
        viewModel.$books
            .dropFirst() // Ignore initial state
            .sink { books in
                XCTAssertEqual(books.count, 2)
                XCTAssertEqual(self.viewModel.rank1Book?.title, "Book 1")
                XCTAssertNil(self.viewModel.errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.loadBooks()
        wait(for: [expectation], timeout: 1)
    }

    func testLoadBooks_Failure() {
        // given
        service.shouldFail = true

        let expectation = expectation(description: "Error should be displayed")

        // when
        viewModel.$errorMessage
            .dropFirst()
            .sink { message in
                if let message = message {
                    XCTAssertEqual(message, "Error fetching books: Mock error")
                    XCTAssertTrue(self.viewModel.books.isEmpty)
                    XCTAssertNil(self.viewModel.rank1Book)
                    XCTAssertFalse(self.viewModel.isLoading)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadBooks()
        wait(for: [expectation], timeout: 1)
    }
}
