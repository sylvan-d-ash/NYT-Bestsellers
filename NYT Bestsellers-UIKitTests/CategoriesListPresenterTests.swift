//
//  CategoriesListPresenterTests.swift
//  NYT Bestsellers-UIKitTests
//
//  Created by Sylvan Ash on 25/02/2025.
//

import XCTest
@testable import NYT_Bestsellers_UIKit

final class CategoriesListPresenterTests: XCTestCase {
    private var presenter: CategoriesListPresenter!
    private var view: MockCategoriesListView!
    private var service: MockCategoriesService!

    private let mockCategories = [
        Category(id: "fiction", name: "Fiction"),
        Category(id: "history", name: "History"),
        Category(id: "history", name: "Science"),
    ]

    @MainActor
    override func setUp() {
        super.setUp()
        view = MockCategoriesListView()
        service = MockCategoriesService()
        presenter = CategoriesListPresenter(view: view, service: service)
    }

    override func tearDown() {
        presenter = nil
        view = nil
        service = nil
        super.tearDown()
    }

    // MARK: - Fetching Categories
    // Test: Fetching categories successfully
    func testFetchCategories_Success() async {
        // Given
        service.result = .success(CategoriesResponse(results: mockCategories))

        await presenter.fetchCategories()

        XCTAssertEqual(view.displayedCategories, mockCategories)

        // Then
        XCTAssertTrue(view.didShowLoading, "showLoading() should be called")
        XCTAssertTrue(view.didHideLoading, "hideLoading() should be called")
        XCTAssertEqual(view.displayedCategories, mockCategories, "Categories should be displayed correctly")
        XCTAssertNil(view.displayedError, "No error should be displayed")
    }

    // Test: Fetching categories with an error
    func testFetchCategories_Failure() async {
        // Given
        let expectedError = NSError(domain: "Network", code: 500, userInfo: nil)
        service.result = .failure(expectedError)

        // When
        await presenter.fetchCategories()

        // Then
        XCTAssertTrue(view.didShowLoading, "showLoading() should be called")
        XCTAssertTrue(view.didHideLoading, "hideLoading() should be called")
        XCTAssertNotNil(view.displayedError, "displayError() should be called")
        XCTAssertEqual(view.displayedError, "Failed to fetch categories: The operation couldn’t be completed. (Network error 500.)", "Error message should match expected output")
        XCTAssertTrue(view.displayedCategories.isEmpty, "Categories should be empty")
    }

    // MARK: - Filtering Categories
    // Test: Filter with Empty Search
    func testFilterCategories_WhenSearchTextIsEmpty_ShouldReturnAllCategories() async {
        // given
        service.result = .success(CategoriesResponse(results: mockCategories))
        await presenter.fetchCategories()

        // when: search with empty string
        await presenter.filterCategories(with: "")

        // then: should return all categories
        XCTAssertEqual(view.displayedCategories.count, 3)
    }

    // Test: Filter with Matching Text
    func testFilterCategories_WhenSearchTextMatches_ShouldReturnFilteredCategories() async {
        // given
        service.result = .success(CategoriesResponse(results: mockCategories))
        await presenter.fetchCategories()

        // when: search with "Sci"
        await presenter.filterCategories(with: "Sci")

        // then: only "science" should be returned
        XCTAssertEqual(view.displayedCategories.count, 1)
        XCTAssertEqual(view.displayedCategories.first?.name, "Science")
    }

    // Test: Filter with No Matches
    func testFilterCategories_WhenNoMatchFound_ShouldReturnAnEmptyArray() async {
        // given
        service.result = .success(CategoriesResponse(results: mockCategories))
        await presenter.fetchCategories()

        // when: search with "Music"
        await presenter.filterCategories(with: "Music")

        // then: should return an empty array
        XCTAssertTrue(view.displayedCategories.isEmpty)
    }

    // Test: Filter is Case Insensitive
    func testFilterCategories_WhenSearchTextIsLowercase_ShouldStillMatch() async {
        // given
        service.result = .success(CategoriesResponse(results: mockCategories))
        await presenter.fetchCategories()

        // when: search with lowercase "scie"
        await presenter.filterCategories(with: "scie")

        // then: only return "Science" category
        XCTAssertEqual(view.displayedCategories.count, 1)
        XCTAssertEqual(view.displayedCategories.first?.name, "Science")
    }
}
