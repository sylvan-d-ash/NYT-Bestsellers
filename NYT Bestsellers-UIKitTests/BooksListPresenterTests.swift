//
//  BooksListPresenterTests.swift
//  NYT Bestsellers-UIKitTests
//
//  Created by Sylvan Ash on 28/02/2025.
//

import Foundation
import XCTest
@testable import NYT_Bestsellers_UIKit

final class BooksListPresenterTests: XCTestCase {
    private var presenter: BooksListPresenter!
    private var view: MockBooksListView!
    private var service: MockBooksService!
    private var category: NYT_Bestsellers_UIKit.Category!

    @MainActor 
    override func setUp() {
        super.setUp()
        view = MockBooksListView()
        service = MockBooksService()
        category = NYT_Bestsellers_UIKit.Category(id: "fiction", name: "Fiction")
        presenter = BooksListPresenter(category: category, view: view, service: service)
    }

    override func tearDown() {
        presenter = nil
        view = nil
        service = nil
        category = nil
        super.tearDown()
    }

    func testFetchBooks_Success() async {
        // given
        let books = [
            Book(rank: 1, title: "Book 1", author: "Test Author", publisher: "", previousRank: 1, isbn13: "abcd1234", description: "", imageUrl: ""),
            Book(rank: 2, title: "Book 2", author: "Test Author 2", publisher: "", previousRank: 2, isbn13: "bcde2345", description: "", imageUrl: ""),
        ]
        let response = BooksResponse(count: books.count, results: BooksResponse.Results(books: books))
        service.result = .success(response)

        // when
        await presenter.fetchBooks()

        // then
        XCTAssertTrue(view.showLoadingCalled)
        XCTAssertTrue(view.hideLoadingCalled)
        XCTAssertEqual(view.displayedBooks, books)
        XCTAssertNil(view.displayedError)
    }

    func testFetchBooks_Failure() async {
        // given
        let error = NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        service.result = .failure(error)

        // when
        await presenter.fetchBooks()

        // then
        XCTAssertTrue(view.showLoadingCalled)
        XCTAssertTrue(view.hideLoadingCalled)
        XCTAssertEqual(view.displayedError, "Mock error")
        XCTAssertTrue(view.displayedBooks.isEmpty)
    }
}
