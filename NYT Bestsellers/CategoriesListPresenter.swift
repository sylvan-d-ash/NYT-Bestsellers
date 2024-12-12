//
//  CategoriesListPresenter.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 12/12/2024.
//

import Foundation

protocol CategoriesListView: AnyObject {
    func showLoading()
    func hideLoading()
    func displayCategories(_ categories: [Any])
    func displayError(_ error: String)
}

final class CategoriesListPresenter {
    private weak var view: CategoriesListView?

    init(view: CategoriesListView? = nil) {
        self.view = view
    }

    func fetchCategories() {
        //
    }
}
