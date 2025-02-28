//
//  BooksListPresenter.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 27/12/2024.
//

import Foundation

protocol BooksListView: AnyObject {
    func showLoading()
    func hideLoading()
    func display(_ books: [Book])
    func displayError(_ error: String)
}

@MainActor
final class BooksListPresenter {
    private weak var view: BooksListView?
    private let category: Category
    private let service: BooksServiceProtocol
    private var totalBooks = 0

    init(category: Category, view: BooksListView, service: BooksServiceProtocol = BooksService()) {
        self.category = category
        self.view = view
        self.service = service
    }

    func fetchBooks() async {
        view?.showLoading()
        defer { view?.hideLoading() }

        let result = await service.fetchBooks(for: category.id)
        switch result {
        case .failure(let error):
            view?.displayError(error.localizedDescription)
        case .success(let response):
            totalBooks = response.count
            view?.display(response.results.books)
        }
    }
}
