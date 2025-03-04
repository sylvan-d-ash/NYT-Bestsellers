//
//  MockBooksListView.swift
//  NYT Bestsellers-UIKitTests
//
//  Created by Sylvan Ash on 28/02/2025.
//

import Foundation
@testable import NYT_Bestsellers_UIKit

final class MockBooksListView: BooksListView {
    private(set) var showLoadingCalled = false
    private(set) var hideLoadingCalled = false
    private(set) var displayedBooks = [Book]()
    private(set) var displayedError: String?

    func showLoading() {
        showLoadingCalled = true
    }

    func hideLoading() {
        hideLoadingCalled = true
    }

    func display(_ books: [Book]) {
        displayedBooks = books
    }

    func displayError(_ error: String) {
        displayedError = error
    }
}
