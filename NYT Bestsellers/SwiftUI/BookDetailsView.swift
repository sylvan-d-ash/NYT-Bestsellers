//
//  BookDetailsView.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 12/02/2025.
//

import SwiftUI

private struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .bold()

            Text(value)
                .font(.caption)
                .foregroundStyle(Color.gray)
        }
    }
}

struct BookDetailsView: View {
    let book: Book

    private var previousRank: String {
        if book.previousRank != 0 {
            return "#\(book.previousRank)"
        }
        return "N/A"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top, spacing: 16) {
                    AsyncImage(url: URL(string: book.imageUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 160, height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    } placeholder: {
                        ProgressView()
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        DetailRow(title: "PUBLISHER", value: book.publisher)
                        DetailRow(title: "ISBN", value: book.isbn13)
                        DetailRow(title: "CURRENT RANK", value: "#\(book.rank)")
                        DetailRow(title: "PREVIOUS RANK", value: previousRank)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(book.title)
                        .font(.title)
                        .bold()

                    Text(book.author)
                        .font(.title3)
                        .foregroundStyle(Color.gray)

                    Divider()
                        .frame(height: 2.0)
                        .background(Color.gray)
                }

                Text(book.description)
                    .font(.body)

                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .navigationTitle(book.title)
    }
}

#Preview {
    let book = Book(rank: 1,
                    title: "Oathbringer",
                    author: "Brandon",
                    publisher: "Penguin",
                    previousRank: 4,
                    isbn13: "123123123",
                    description: "Shall I compare you to a summer's day?",
                    imageUrl: "https://storage.googleapis.com/du-prd/books/images/9781464227325.jpg")
    return BookDetailsView(book: book)
}
