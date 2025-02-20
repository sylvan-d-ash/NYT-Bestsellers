//
//  CategoriesViewModel.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 06/02/2025.
//

import Foundation
import Combine

final class CategoriesViewModel: ObservableObject {
    @Published private(set) var categories: [Category] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let service: CategoriesServiceProtocol
    private var cancellabes = Set<AnyCancellable>()

    init(service: CategoriesServiceProtocol = CategoriesService()) {
        self.service = service
    }

    func loadCategories() {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        service.fetchCategories()
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false

                switch completion {
                case .failure(let error):
                    self.errorMessage = "Failed to load categories: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.isLoading = false
                self?.categories = response.results
            }
            .store(in: &cancellabes)
    }
}
