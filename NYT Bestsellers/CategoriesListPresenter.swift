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
    func displayCategories()
    func displayError(_ error: String)
}

final class CategoriesListPresenter {
    private weak var view: CategoriesListView?
    private let service: CategoriesListService
    private var categories = [Category]()
    private var cancellables = Set<AnyCancellable>()

    init(view: CategoriesListView? = nil, service: CategoriesListService = APIService()) {
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
            } receiveValue: { [weak self] categories in
                self?.categories = categories
                self?.view?.displayCategories()
            }
            .store(in: &cancellables)
    }

    func getCategoryName(forRowAt index: Int) -> String {
        return categories[index].name
    }
}
