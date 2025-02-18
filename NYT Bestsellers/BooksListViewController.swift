//
//  BooksListViewController.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 20/12/2024.
//

import UIKit

final class CardViewCell: UICollectionViewCell {
    private let bookImage = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView()
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
        loadingIndicator.startAnimating()
        // TODO: load image & show placeholder
    }

    private func setupSubviews() {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.105, green: 0.776, blue: 0.744, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        contentView.addSubview(view)
        view.fillParent()

        let imageSection = setupImageSection()
//        view.addSubview(imageSection)
//        imageSection.fillParentVertically(16)
//        imageSection.alignToLeft(16)
        let infoSection = setupInfoSection()
        let stackview = UIStackView(arrangedSubviews: [imageSection, infoSection])
        stackview.axis = .horizontal
        stackview.spacing = 8
        stackview.alignment = .leading
        view.addSubview(stackview)
        stackview.fillParent(16)
    }

    private func setupImageSection() -> UIView {
        let view = UIView()

        bookImage.image = UIImage(named: "Oathbringer")
        bookImage.layer.cornerRadius = 10
        bookImage.layer.masksToBounds = true
        bookImage.contentMode = .scaleAspectFill
        view.addSubview(bookImage)
        bookImage.setWidthConstraint(110)
        bookImage.setHeightConstraint(150)
        bookImage.fillParent()

        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        view.addSubview(loadingIndicator)
        loadingIndicator.centerInParent()

        return view
    }

    private func setupInfoSection() -> UIView {
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

    private func setupTitleSection() -> UIView {
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

    private func setupPublisherAndISBNSection() -> UIView {
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
        // TODO: load image + show placeholder
    }

    private func setupSubviews() {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        contentView.addSubview(view)
        view.fillParent()

        coverImageView.image = UIImage(named: "Radiance")
        coverImageView.layer.cornerRadius = 12
        coverImageView.layer.masksToBounds = true
        coverImageView.contentMode = .scaleAspectFill
        coverImageView.setHeightConstraint(150)
        view.addSubview(coverImageView)
        coverImageView.fillParent(2)
    }
}

final class BooksListViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let category: Category
    private var presenter: BooksListPresenter!
    private var books: [Book] = []
    private let loadingView = UIView()

    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = BooksListPresenter(category: category, view: self)
        setupNavigationBar()
        setupSubviews()
        setupLoadingView()

        Task {
            await presenter.fetchBooks()
        }
    }
}

private extension BooksListViewController {
    func setupNavigationBar() {
        navigationItem.title = category.name
    }

    func setupSubviews() {
        let layout = configureCellLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CardViewCell.self, forCellWithReuseIdentifier: String(describing: CardViewCell.self))
        collectionView.register(BookViewCell.self, forCellWithReuseIdentifier: String(describing: BookViewCell.self))
        view.addSubview(collectionView)
        collectionView.fillParent()
    }

    func configureCellLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 12
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)

        return layout
    }

    func setupLoadingView() {
        loadingView.backgroundColor = .black
        loadingView.layer.opacity = 0.5
        loadingView.isHidden = true
        view.addSubview(loadingView)
        loadingView.fillParent()
        view.sendSubviewToBack(loadingView)

        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.startAnimating()
        loadingView.addSubview(activityIndicator)
        activityIndicator.centerInParent()
    }
}

extension BooksListViewController: BooksListView {
    func showLoading() {
        loadingView.isHidden = false
        view.bringSubviewToFront(loadingView)
    }

    func hideLoading() {
        loadingView.isHidden = true
        view.sendSubviewToBack(loadingView)
    }

    func display(_ books: [Book]) {
        self.books = books
        collectionView.reloadData()
    }

    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension BooksListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let book = books[indexPath.row]

        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CardViewCell.self), for: indexPath) as? CardViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(book)
            return cell
        }

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BookViewCell.self), for: indexPath) as? BookViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(book)
        return cell
    }
}

extension BooksListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO: navigate to book details
    }
}

extension BooksListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12

        if indexPath.row == 0 {
            let width = view.bounds.width - (2 * spacing)
            let height: CGFloat = /* image height */ 150 + /* top + bottom padding */ (2 * 16)
            return CGSize(width: width, height: height)
        }

        let numberOfColumns: CGFloat = 3
        let totalSpacing = (numberOfColumns - 1) * 2
        let availableWidth = view.bounds.width - (totalSpacing + (2 * spacing) + (2 * 10))
        let cellWidth = floor(availableWidth / numberOfColumns)

        let height: CGFloat = /* image height */ 150 + /* top + bottom padding */ (2 * 2)
        return CGSize(width: cellWidth, height: height)
    }
}
