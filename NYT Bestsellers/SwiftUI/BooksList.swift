//
//  BooksList.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 10/02/2025.
//

import SwiftUI

private struct Rank1BookView: View {
    @State var book: Book

    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: book.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView(book.title)
                    .frame(width: 110, height: 150)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(book.title)
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.042, green: 0.343, blue: 0.34))
                    .bold()

                Text(book.author)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Publisher:")
                        Text("ISBN 13:")
                    }
                    .foregroundStyle(Color(red: 0.042, green: 0.343, blue: 0.34))

                    VStack(alignment: .leading) {
                        Text(book.publisher)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                        Text(book.isbn13)
                    }
                    .foregroundStyle(Color(red: 0.784, green: 0.42, blue: 0.479))
                }
                .font(.caption)
                .fontWeight(.semibold)

                Text(book.description)
                    .font(.caption)
                    .multilineTextAlignment(.leading)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color(red: 0.105, green: 0.776, blue: 0.744))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 5)
    }
}

struct BooksList: View {
    @StateObject var viewModel: BooksListViewModel
    private let category: Category

    init(category: Category) {
        self.category = category
        _viewModel = StateObject(wrappedValue: BooksListViewModel(category: category))
    }

    var body: some View {
        ScrollView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .padding()
                } else {
                    if let book = viewModel.rank1Book {
                        NavigationLink(destination: BookDetailsView(book: book)) {
                            Rank1BookView(book: book)
                        }
                    }

                    LazyVGrid(columns: generateGridItems(), spacing: 12) {
                        ForEach(viewModel.books, id: \.rank) { book in
                            NavigationLink(destination: BookDetailsView(book: book)) {
                                AsyncImage(url: URL(string: book.imageUrl)) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } placeholder: {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .preferredColorScheme(.dark)
        .navigationTitle(category.name)
        .task {
            await viewModel.loadBooks()
        }
        // NOTE: this causes the progress indicator to display above the title which isn't
        // the desired effect
//        .refreshable {
//            await viewModel.loadBooks()
//        }
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

    private func generateGridItems() -> [GridItem] {
        var gridItems: [GridItem] = []

        // 3 columns per row
        gridItems.append(contentsOf: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])

        return gridItems
    }
}

#Preview {
    let id = "combined-print-and-e-book-fiction"
    let category = Category(id: id, name: "Print Fiction")
    return NavigationStack { BooksList(category: category) }
}
