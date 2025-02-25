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

final class CategoriesListPresenter {
    private weak var view: CategoriesListView?
    private let service: CategoriesServiceProtocol

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
            view?.display(response.results)
        }

        view?.hideLoading()
    }
}
