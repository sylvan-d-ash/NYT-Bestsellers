//
//  CardViewCell.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 18/02/2025.
//

import UIKit
import SDWebImage

final class CardViewCell: UICollectionViewCell {
    private let bookImage = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let publisherLabel = UILabel()
    private let isbnLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(_ book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author
        publisherLabel.text = book.publisher
        isbnLabel.text = book.isbn13
        descriptionLabel.text = book.description

        bookImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        bookImage.sd_setImage(with: URL(string: book.imageUrl))
    }

    static func getViewHeight() -> CGFloat {
        return Dimensions.imageHeight + (2 * Dimensions.imagePadding) + (2 * Dimensions.padding)
    }
}

private extension CardViewCell {
    enum Dimensions {
        static let padding: CGFloat = 16
        static let imageWidth: CGFloat = 110
        static let imageHeight: CGFloat = 150
        static let imagePadding: CGFloat = 2
        static let radius: CGFloat = 10
    }

    func setupSubviews() {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.105, green: 0.776, blue: 0.744, alpha: 1)
        view.layer.cornerRadius = Dimensions.radius
        view.layer.masksToBounds = true
        contentView.addSubview(view)
        view.fillParent()

        let imageSection = setupImageSection()
        let infoSection = setupInfoSection()
        let stackview = UIStackView(arrangedSubviews: [imageSection, infoSection])
        stackview.axis = .horizontal
        stackview.spacing = 8
        stackview.alignment = .leading
        view.addSubview(stackview)
        stackview.fillParent(Dimensions.padding)
    }

    func setupImageSection() -> UIView {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = Dimensions.radius
        view.layer.masksToBounds = true

        bookImage.layer.cornerRadius = Dimensions.radius
        bookImage.layer.masksToBounds = true
        bookImage.contentMode = .scaleAspectFill
        view.addSubview(bookImage)
        bookImage.setWidthConstraint(Dimensions.imageWidth)
        bookImage.setHeightConstraint(Dimensions.imageHeight)
        bookImage.fillParent(Dimensions.imagePadding)

        return view
    }

    func setupInfoSection() -> UIView {
        let titleSection = setupTitleSection()
        let publisherSection = setupPublisherAndISBNSection()

        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textColor = .label
        descriptionLabel.numberOfLines = 0

        let view = UIStackView(arrangedSubviews: [titleSection, publisherSection, descriptionLabel])
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading

        return view
    }

    func setupTitleSection() -> UIView {
        titleLabel.numberOfLines = 2
        titleLabel.minimumScaleFactor = 0.7
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = .boldSystemFont(ofSize: 17)

        authorLabel.numberOfLines = 1
        authorLabel.minimumScaleFactor = 0.7
        authorLabel.adjustsFontSizeToFitWidth = true
        authorLabel.font = .systemFont(ofSize: 15, weight: .semibold)

        let view = UIStackView(arrangedSubviews: [titleLabel, authorLabel])
        view.axis = .vertical
        view.spacing = 8
        view.alignment = .leading

        return view
    }

    func setupPublisherAndISBNSection() -> UIView {
        let pubTitleLabel = UILabel()
        pubTitleLabel.text = "Publisher:"
        pubTitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        pubTitleLabel.textColor = UIColor(red: 0.042, green: 0.343, blue: 0.34, alpha: 1)

        publisherLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        publisherLabel.textColor = UIColor(red: 0.784, green: 0.42, blue: 0.479, alpha: 1)
        publisherLabel.numberOfLines = 1
        publisherLabel.minimumScaleFactor = 0.7
        publisherLabel.adjustsFontSizeToFitWidth = true

        let isbnTitleLabel = UILabel()
        isbnTitleLabel.text = "Publisher:"
        isbnTitleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        isbnTitleLabel.textColor = UIColor(red: 0.042, green: 0.343, blue: 0.34, alpha: 1)

        isbnLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        isbnLabel.textColor = UIColor(red: 0.784, green: 0.42, blue: 0.479, alpha: 1)

        let leftView = UIStackView(arrangedSubviews: [pubTitleLabel, isbnTitleLabel])
        leftView.axis = .vertical
        leftView.spacing = 4
        leftView.alignment = .leading

        let rightView = UIStackView(arrangedSubviews: [publisherLabel, isbnLabel])
        rightView.axis = .vertical
        rightView.spacing = 4
        rightView.alignment = .leading

        let view = UIStackView(arrangedSubviews: [leftView, rightView])
        view.axis = .horizontal
        view.spacing = 8
        view.alignment = .leading

        return view
    }
}
