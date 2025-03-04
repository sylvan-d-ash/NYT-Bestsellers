//
//  BooksListViewModel.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 10/02/2025.
//

import Foundation
import Combine

//@MainActor
final class BooksListViewModel: ObservableObject {
    @Published private(set) var rank1Book: Book?
    @Published private(set) var books: [Book] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let category: Category
    private let service: BooksServiceProtocol
    private var totalBooks = 0
    private var cancellables = Set<AnyCancellable>()

    init(category: Category, service: BooksServiceProtocol = BooksService()) {
        self.category = category
        self.service = service
    }

    func loadBooks() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        service.fetchBooks(for: category.id)
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                self.isLoading = false

                switch completion {
                case .failure(let error):
                    errorMessage = "Error fetching books: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { response in
                self.totalBooks = response.count

                var books = response.results.books
                if !books.isEmpty {
                    self.rank1Book = books.removeFirst()
                    self.books = books
                } else {
                    self.rank1Book = nil
                    self.books = []
                }
            }
            .store(in: &cancellables)
    }
}
