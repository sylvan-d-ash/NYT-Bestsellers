//
//  CategoriesViewModelTests.swift
//  NYT Bestsellers-SwiftUITests
//
//  Created by Sylvan Ash on 27/02/2025.
//

import XCTest
import Combine
@testable import NYT_Bestsellers_SwiftUI

final class CategoriesViewModelTests: XCTestCase {
    private var viewModel: CategoriesViewModel!
    private var service: MockCategoriesService!
    private var cancellables: Set<AnyCancellable>!

    private let mockCategories = [
        Category(id: "fiction", name: "Fiction"),
        Category(id: "history", name: "History"),
        Category(id: "history", name: "Science"),
    ]

    override func setUp() {
        super.setUp()
        service = MockCategoriesService()
        viewModel = CategoriesViewModel(service: service)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        service = nil
        cancellables = nil
        super.tearDown()
    }

    // MARK: Load Categories
    // Test: isLoading is TRUE when fetching starts and FALSE when fetching ends
    func testIsLoadingState() {
        let expectationStart = expectation(description: "isLoading should be true when fetching starts")
        let expectationEnd = expectation(description: "isLoading should be false when fetching ends")

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

        viewModel.loadCategories()

        wait(for: [expectationStart, expectationEnd], timeout: 1.0)

        XCTAssertEqual(observedStates, [true, false], "isLoading should transition from true to false")
    }

    // Test: Load categories successfully
    func testLoadCategories_Success() {
        service.response = CategoriesResponse(results: mockCategories)
        service.shouldFail = false

        let expectation = expectation(description: "Fetch categories successfully")

        viewModel.$isLoading
            .dropFirst()
            .sink { isLoading in
                if !isLoading {
                    XCTAssertEqual(self.viewModel.filteredCategories.count, 3, "Should have 3 categories")
                    XCTAssertEqual(self.viewModel.filteredCategories.first?.name, "Fiction")
                    XCTAssertNil(self.viewModel.errorMessage)
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadCategories()
        wait(for: [expectation], timeout: 1)
    }

    // Test: Load categories with an error
    func testLoadCategories_Failure() {
        service.shouldFail = true

        let expectation = expectation(description: "Fetch categories fails")

        viewModel.$errorMessage
            .dropFirst()
            .sink { message in
                if let message = message {
                    XCTAssertFalse(self.viewModel.isLoading)
                    XCTAssertEqual(message, "Failed to load categories: Mock error")
                    XCTAssertTrue(self.viewModel.filteredCategories.isEmpty, "Categories should be empty on failure")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.loadCategories()
        wait(for: [expectation], timeout: 1)
    }

    // MARK: Filtering Categories
    // Test: Filter with Empty Search
    func testFilterCategories_WhenSearchTestIsEmpty_ShouldReturnAllCategories() {
        service.response = CategoriesResponse(results: mockCategories)
        viewModel.loadCategories()

        let expectation = expectation(description: "Empty search sould return all categories")

        viewModel.$searchText
            .dropFirst()
            .sink { _ in
                XCTAssertEqual(self.viewModel.filteredCategories.count, 3)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.searchText = ""
        wait(for: [expectation], timeout: 1)
    }

    func testFilterCategories_WhenSearchTestIsEmpty_ShouldReturnAllCategories_AlternativeImplementation() {
        // Given
        service.response = CategoriesResponse(results: mockCategories)
        viewModel.loadCategories()

        // When
        viewModel.searchText = ""

        // Then
        XCTAssertEqual(viewModel.filteredCategories.count, 3, "Filtered categories should return all items when search is empty")
    }

    /*
     Because `filteredCategories` isn't stored in a @Published variable but instead computed, and the filtering logic doesn't rely on async operations
     `sink` isn't necessary and direct assertion approach is better
     */
    // Test: Filter with Matching Text
    func testFilterCategories_WhenSearchTextMatches_ShouldReturnMatchingResults() {
        // given
        service.response = CategoriesResponse(results: mockCategories)
        viewModel.loadCategories()

        // when: search with "Sci"
        viewModel.searchText = "Sci"

        // then: only "Science" category should be returned
        XCTAssertEqual(viewModel.filteredCategories.count, 1, "Should return only categories containing 'Science'")
        XCTAssertEqual(viewModel.filteredCategories.first?.name, "Science")
    }

    // Test: Filter with No Matches
    func testFilterCategories_WhenNoMatchFound_ShouldReturnAnEmptyArray() {
        // given
        service.response = CategoriesResponse(results: mockCategories)
        viewModel.loadCategories()

        // when: search with "Math"
        viewModel.searchText = "Math"

        // then: should return an empty array
        XCTAssertTrue(self.viewModel.filteredCategories.isEmpty, "Should return an empty array")
    }

    // Test: Filter is Case Insensitive
    func testFilterCategories_WhenSearchTestIsLowercase_ShouldStillMatch() {
        // given
        service.response = CategoriesResponse(results: mockCategories)
        viewModel.loadCategories()

        // when: search with mixed case "sCieNc"
        viewModel.searchText = "sCieNc"

        // then: only "Science" category should be returned
        XCTAssertEqual(viewModel.filteredCategories.count, 1, "Filter should be case insensitive")
        XCTAssertEqual(viewModel.filteredCategories.first?.name, "Science")
    }
}
