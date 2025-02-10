//
//  CategoriesView.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 06/02/2025.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject private var viewModel = CategoriesViewModel()

    var body: some View {
        NavigationStack {
            List {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    ForEach(viewModel.categories, id: \.id) { category in
                        NavigationLink(value: category) {
                            Text(category.name)
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Bestsellers Categories")
            .navigationDestination(for: Category.self) { category in
                BooksList(category: category)
            }
            .task {
                viewModel.loadCategories()
            }
            .alert(
                "Error",
                isPresented: .constant(viewModel.errorMessage != nil)
            ) {
                Button("Cancel", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let message = viewModel.errorMessage {
                    Text(message)
                }
            }
        }
    }
}

#Preview {
    CategoriesView()
}
