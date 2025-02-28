//
//  MockBooksListView.swift
//  NYT Bestsellers-UIKitTests
//
//  Created by Sylvan Ash on 28/02/2025.
//

import Foundation
@testable import NYT_Bestsellers_UIKit

final class MockBooksListView: BooksListView {
    private(set) var didShowLoading = false
    private(set) var didHideLoading = false
    private(set) var displayedBooks = [Book]()
    private(set) var displayedError: String?

    func showLoading() {
        didShowLoading = true
    }

    func hideLoading() {
        didHideLoading = true
    }

    func display(_ books: [Book]) {
        displayedBooks = books
    }

    func displayError(_ error: String) {
        displayedError = error
    }
}
