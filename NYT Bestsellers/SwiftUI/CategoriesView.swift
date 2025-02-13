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
                    VStack {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.categories, id: \.id) { category in
                        ZStack(alignment: .leading) {
                            NavigationLink(value: category) {
                                EmptyView()
                            }
                            .opacity(0)

                            Text(category.name)
                        }
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(top: 7, leading: 0, bottom: 7, trailing: 0))
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Bestseller Categories")
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
