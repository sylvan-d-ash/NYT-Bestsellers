//
//  BookViewCell.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 18/02/2025.
//

import UIKit
import SDWebImage

final class BookViewCell: UICollectionViewCell {
    private let coverImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ book: Book) {
        coverImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        coverImageView.sd_setImage(with: URL(string: book.imageUrl))
    }

    static func getViewHeight() -> CGFloat {
        return Dimensions.imageHeight + (2 * Dimensions.padding)
    }
}

private extension BookViewCell {
    enum Dimensions {
        static let imageHeight: CGFloat = 150
        static let radius: CGFloat = 12
        static let padding: CGFloat = 2
    }

    func setupSubviews() {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Dimensions.radius
        view.layer.masksToBounds = true
        contentView.addSubview(view)
        view.fillParent()

        coverImageView.layer.cornerRadius = Dimensions.radius
        coverImageView.layer.masksToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.setHeightConstraint(Dimensions.imageHeight)
        view.addSubview(coverImageView)
        coverImageView.fillParent(Dimensions.padding)
    }
}
