//
//  MockCategoriesListView.swift
//  NYT Bestsellers-UIKitTests
//
//  Created by Sylvan Ash on 24/02/2025.
//

import Foundation
@testable import NYT_Bestsellers_UIKit

final class MockCategoriesListView: CategoriesListView {
    private(set) var didShowLoading = false
    private(set) var didHideLoading = false
    private(set) var displayedCategories: [NYT_Bestsellers_UIKit.Category] = []
    private(set) var displayedError: String?

    func showLoading() {
        didShowLoading = true
    }

    func hideLoading() {
        didHideLoading = true
    }

    func display(_ categories: [NYT_Bestsellers_UIKit.Category]) {
        displayedCategories = categories
    }

    func displayError(_ error: String) {
        displayedError = error
    }
}
