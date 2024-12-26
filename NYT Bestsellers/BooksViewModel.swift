//
//  BooksViewModel.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 20/12/2024.
//

import Combine

final class BooksViewModel: ObservableObject {
    @Published private(set) var books: [Book] = []
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    private let category: Category
    private let service: BooksServiceProtocol
    private var totalBooks = 0
    private var cancellables = Set<AnyCancellable>()

    init(category: Category, service: BooksServiceProtocol = BooksService()) {
        self.category = category
        self.service = service
    }

    func fetchBooks() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        service.fetchBooks(for: category.id)
            .sink { [weak self] completion in
                guard let `self` = self else { return }
                self.isLoading = false

                switch completion {
                case .finished: break
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = "Failed to fetch books: \(error.localizedDescription)"
                }
            } receiveValue: { [weak self] response in
                self?.books = response.results.books
                self?.totalBooks = response.count
            }
            .store(in: &cancellables)
    }
}
