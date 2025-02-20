//
//  CategoriesListPresenter.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 12/12/2024.
//

import Foundation
import Combine

protocol CategoriesListView: AnyObject {
    func showLoading()
    func hideLoading()
    func display(_ categories: [Category])
    func displayError(_ error: String)
}

final class CategoriesListPresenter {
    private weak var view: CategoriesListView?
    private let service: CategoriesServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(view: CategoriesListView? = nil, service: CategoriesServiceProtocol = CategoriesService()) {
        self.view = view
        self.service = service
    }

    func fetchCategories() {
        view?.showLoading()

        service.fetchCategories()
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                self.view?.hideLoading()

                switch completion {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.view?.displayError("Failed to fetch categories: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                let categories = response.results
                self?.view?.display(categories)
            }
            .store(in: &cancellables)
    }
}
