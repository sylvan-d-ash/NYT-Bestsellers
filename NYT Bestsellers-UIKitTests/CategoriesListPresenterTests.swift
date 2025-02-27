//
//  CategoriesListPresenterTests.swift
//  NYT Bestsellers-UIKitTests
//
//  Created by Sylvan Ash on 25/02/2025.
//

import XCTest
@testable import NYT_Bestsellers_UIKit

final class CategoriesListPresenterTests: XCTestCase {
    var presenter: CategoriesListPresenter!
    var mockView: MockCategoriesListView!
    var mockService: MockCategoriesService!

    @MainActor
    override func setUp() {
        super.setUp()
        mockView = MockCategoriesListView()
        mockService = MockCategoriesService()
        presenter = CategoriesListPresenter(view: mockView, service: mockService)
    }

    override func tearDown() {
        presenter = nil
        mockView = nil
        mockService = nil
        super.tearDown()
    }

    // Test: Fetching categories successfully
    func testFetchCategories_Success() async {
        // Given
        let mockCategories = [
            Category(id: "fiction", name: "Fiction"),
            Category(id: "history", name: "History")
        ]
        mockService.result = .success(CategoriesResponse(results: mockCategories))

        await presenter.fetchCategories()

        XCTAssertEqual(mockView.displayedCategories, mockCategories)

        // Then
        XCTAssertTrue(mockView.didShowLoading, "showLoading() should be called")
        XCTAssertTrue(mockView.didHideLoading, "hideLoading() should be called")
        XCTAssertEqual(mockView.displayedCategories, mockCategories, "Categories should be displayed correctly")
        XCTAssertNil(mockView.displayedError, "No error should be displayed")
    }

    // Test: Fetching categories with an error
    func testFetchCategories_Failure() async {
        // Given
        let expectedError = NSError(domain: "Network", code: 500, userInfo: nil)
        mockService.result = .failure(expectedError)

        // When
        await presenter.fetchCategories()

        // Then
        XCTAssertTrue(mockView.didShowLoading, "showLoading() should be called")
        XCTAssertTrue(mockView.didHideLoading, "hideLoading() should be called")
        XCTAssertNotNil(mockView.displayedError, "displayError() should be called")
        XCTAssertEqual(mockView.displayedError, "Failed to fetch categories: The operation couldn’t be completed. (Network error 500.)", "Error message should match expected output")
        XCTAssertTrue(mockView.displayedCategories.isEmpty, "Categories should be empty")
    }
}
