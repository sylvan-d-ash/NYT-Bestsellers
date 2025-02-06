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
                }

                ForEach(viewModel.categories, id: \.id) { category in
                    NavigationLink(value: category) {
                        Text(category.name)
                    }
                }
            }
        }
        .navigationTitle("Bestsellers Categories")
        .navigationDestination(for: Category.self) { category in
            // TODO:
            // load books list view and pass `category` object
        }
        .task {
            viewModel.loadCategories()
        }
        .alert(
            "Error",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil }}
            ),
            presenting: viewModel.errorMessage) { _ in
                Button("Cancel", role: .cancel) {}
            } message: { message in
                Text(message)
            }
    }
}

#Preview {
    CategoriesView()
}
