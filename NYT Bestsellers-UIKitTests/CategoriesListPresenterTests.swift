//
//  CategoriesListPresenterTests.swift
//  NYT Bestsellers-UIKitTests
//
//  Created by Sylvan Ash on 25/02/2025.
//

import XCTest
import Combine
@testable import NYT_Bestsellers_UIKit

final class CategoriesListPresenterTests: XCTestCase {
    var presenter: CategoriesListPresenter!
    var mockView: MockCategoriesListView!
    var mockService: MockCategoriesService!
    var cancellables: Set<AnyCancellable> = []

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
        cancellables.removeAll()
        super.tearDown()
    }

    // Test: Fetching categories successfully
    func testFetchCategories_Success() {
        // Given
        let mockCategories = [
            Category(id: "fiction", name: "Fiction"),
            Category(id: "history", name: "History")
        ]
        mockService.mockCategories = mockCategories

        // When
        presenter.fetchCategories()

        // Then
        XCTAssertTrue(mockView.didShowLoading, "showLoading() should be called")
        XCTAssertTrue(mockView.didHideLoading, "hideLoading() should be called")
        XCTAssertEqual(mockView.displayedCategories, mockCategories, "Categories should be displayed correctly")
        XCTAssertNil(mockView.displayedError, "No error should be displayed")
    }

    // Test: Fetching categories with an error
    func testFetchCategories_Failure() {
        // Given
        mockService.shouldReturnError = true

        // When
        presenter.fetchCategories()

        // Then
        XCTAssertTrue(mockView.didShowLoading, "showLoading() should be called")
        XCTAssertTrue(mockView.didHideLoading, "hideLoading() should be called")
        XCTAssertNotNil(mockView.displayedError, "displayError() should be called")
        XCTAssertEqual(mockView.displayedError, "Failed to fetch categories: Network error", "Error message should match expected output")
        XCTAssertTrue(mockView.displayedCategories.isEmpty, "Categories should be empty")
    }
}
