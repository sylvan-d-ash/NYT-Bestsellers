//
//  Design.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 28/01/2025.
//

import SwiftUI

struct Card: View {
    var body: some View {
        HStack(alignment: .top) {
            Image("Placeholder")
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 8) {
                Text("The Dollmaker")
                    .font(.headline)
                    .foregroundStyle(Color(red: 0.042, green: 0.343, blue: 0.34))
                    .bold()

                Text("Shane Davis")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                VStack(alignment: .leading) {
                    HStack {
                        Text("Published:")
                            .foregroundStyle(Color(red: 0.042, green: 0.343, blue: 0.34))
                        Text("2019")
                            .foregroundStyle(Color(red: 0.784, green: 0.42, blue: 0.479))
                    }

                    HStack {
                        Text("Pages:")
                            .foregroundStyle(Color(red: 0.042, green: 0.343, blue: 0.34))
                        Text("600")
                            .foregroundStyle(Color(red: 0.784, green: 0.42, blue: 0.479))
                    }
                }
                .font(.caption)
                .fontWeight(.semibold)

                Text("Dollmaker Vinci Code is a 2019 mystery thriller novel by Shane Davies, his 2nd Novel")
                    .font(.caption)
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

struct Design: View {
    var images = ["Kings", "Oathbringer", "Radiance", "Placeholder", "Dragons", "Dance", "Feast"]

    var body: some View {
        ScrollView {
            Card()

            LazyVGrid(columns: generateGridItems(), spacing: 12) {

                ForEach(images, id: \.self) { imagename in
                    Image(imagename)
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color(red: 0.138, green: 0.157, blue: 0.212)) // AppBlack background
    }

    private func generateGridItems() -> [GridItem] {
        var gridItems: [GridItem] = []

        // Remaining rows: 3 columns per row
        gridItems.append(contentsOf: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())])

        return gridItems
    }
}

#Preview {
    Design()
}
