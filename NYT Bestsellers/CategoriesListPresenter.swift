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
    func display(_ categories: [Category])
    func displayError(_ error: String)
}

@MainActor
final class CategoriesListPresenter {
    private weak var view: CategoriesListView?
    private let service: CategoriesServiceProtocol
    private var categories: [Category] = []

    init(view: CategoriesListView? = nil, service: CategoriesServiceProtocol = CategoriesService()) {
        self.view = view
        self.service = service
    }

    func fetchCategories() async {
        view?.showLoading()

        let result = await service.fetchCategories()
        switch result {
        case .failure(let error):
            view?.displayError("Failed to fetch categories: \(error.localizedDescription)")
        case .success(let response):
            categories = response.results
            view?.display(categories)
        }

        view?.hideLoading()
    }

    func filterCategories(with text: String) {
        var filterCategories = [Category]()

        if text.isEmpty {
            filterCategories = categories
        } else {
            filterCategories = categories.filter { $0.name.localizedCaseInsensitiveContains(text) }
        }

        view?.display(filterCategories)
    }
}
