//
//  BooksList.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 10/02/2025.
//

import SwiftUI

struct BooksList: View {
    @StateObject var viewModel: BooksListViewModel
    private let category: Category

    init(category: Category) {
        self.category = category
        _viewModel = StateObject(wrappedValue: BooksListViewModel(category: category))
    }

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                if let book = viewModel.rank1Book {
                    Card()
                }

                List {
                    ForEach(viewModel.books, id: \.rank) { book in
                        //
                    }
                }
            }
        }
        .navigationTitle(category.name)
        .task {
            await viewModel.loadBooks()
        }
    }
}

#Preview {
    let id = "combined-print-and-e-book-fiction"
    let category = Category(id: id, name: "Print Fiction")
    return BooksList(category: category)
}
