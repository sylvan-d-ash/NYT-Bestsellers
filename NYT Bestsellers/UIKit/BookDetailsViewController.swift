//
//  BookDetailsViewController.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 19/02/2025.
//

import UIKit
import SDWebImage

final class BookDetailsViewController: UIViewController {
    private let book: Book

    init(book: Book) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSubviews()
    }
}

private extension BookDetailsViewController {
    func setupNavigationBar() {
        //navigationItem.title = book.title
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func setupSubviews() {
        view.backgroundColor = .black

        let scrollview = UIScrollView()
        view.addSubview(scrollview)
        scrollview.fillParent()

        let topSection = setupTopSection()
        let titleSection = setupTitleSection()

        let descriptionLabel = UILabel()
        descriptionLabel.text = book.description
        descriptionLabel.font = .systemFont(ofSize: 12)
        descriptionLabel.textColor = .white
        descriptionLabel.numberOfLines = 0

        let stackview = UIStackView(arrangedSubviews: [topSection, titleSection, descriptionLabel])
        stackview.axis = .vertical
        stackview.spacing = 16
        stackview.alignment = .leading

        scrollview.addSubview(stackview)
        stackview.fillParent()
        stackview.matchWidthOf(view)
    }

    func setupTopSection() -> UIView {
        let coverImageSection = setupBookCoverSection()
        let infoSection = setupInfoSection()

        let stackview = UIStackView(arrangedSubviews: [coverImageSection, infoSection])
        stackview.axis = .horizontal
        stackview.spacing = 16
        stackview.alignment = .leading

        return stackview
    }

    func setupTitleSection() -> UIView {
        let bookTitle = UILabel()
        bookTitle.text = book.title
        bookTitle.font = .boldSystemFont(ofSize: 16)
        bookTitle.textColor = .white
        bookTitle.numberOfLines = 0

        let authorLabel = UILabel()
        authorLabel.text = book.author
        authorLabel.numberOfLines = 0
        authorLabel.font = .systemFont(ofSize: 12)
        authorLabel.textColor = .gray

        let divider = UIView()
        divider.setHeightConstraint(2)
        divider.backgroundColor = .gray

        let stackview = UIStackView(arrangedSubviews: [bookTitle, authorLabel, divider])
        stackview.axis = .vertical
        stackview.spacing = 8
        stackview.alignment = .leading

        return stackview
    }

    func setupBookCoverSection() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_setImage(with: URL(string: book.imageUrl))

        view.addSubview(imageView)
        imageView.fillParent()
        imageView.setWidthConstraint(160)
        imageView.setHeightConstraint(220)

        return view
    }

    func setupInfoSection() -> UIView {
        let rank = (book.previousRank != 0) ? "#\(book.previousRank)" : "N/A"
        let previousRankRow = setupDetailRow("PREVIOUS RANK", value: rank)
        let publisherRow = setupDetailRow("PUBLISHER", value: book.publisher)
        let isbnRow = setupDetailRow("ISBN", value: book.isbn13)
        let rankRow = setupDetailRow("CURRENT RANK", value: "#\(book.rank)")

        let stackview = UIStackView(arrangedSubviews: [publisherRow, isbnRow, rankRow, previousRankRow])
        stackview.axis = .vertical
        stackview.spacing = 10
        stackview.alignment = .leading

        return stackview
    }

    func setupDetailRow(_ title: String, value: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 12, weight: .bold) // 17 bold
        titleLabel.textColor = .white

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 12)
        valueLabel.textColor = .gray
        valueLabel.numberOfLines = 1
        valueLabel.minimumScaleFactor = 0.7
        valueLabel.adjustsFontSizeToFitWidth = true

        let stackview = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackview.axis = .vertical
        stackview.spacing = 4
        stackview.alignment = .leading

        return stackview
    }
}
