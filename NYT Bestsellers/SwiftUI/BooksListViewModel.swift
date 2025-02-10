//
//  BooksListViewModel.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 10/02/2025.
//

import Foundation

final class BooksListViewModel: ObservableObject {
    @Published private(set) var rank1Book: Book?
    @Published private(set) var books: [Book] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let category: Category
    private let service: BooksServiceProtocol
    private var totalBooks = 0

    init(category: Category, service: BooksServiceProtocol = BooksService()) {
        self.category = category
        self.service = service
    }

    func loadBooks() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        let result = await service.fetchBooks(for: category.id)
        switch result {
        case .failure(let error):
            errorMessage = "Error fetching books: \(error.localizedDescription)"
        case .success(let response):
            totalBooks = response.count

            var books = response.results.books
            rank1Book = books.removeFirst()
            self.books = books
        }

        isLoading = false
    }
}
