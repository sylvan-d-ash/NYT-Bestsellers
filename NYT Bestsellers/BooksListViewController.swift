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
        // TODO: load image
    }

    private func setupSubviews() {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.105, green: 0.776, blue: 0.744, alpha: 1)
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true

        let imageSection = setupImageSection()
        view.addSubview(imageSection)
        imageSection.fillParentVertically(16)
        imageSection.alignToLeft(16)
    }

    private func setupImageSection() -> UIView {
        let view = UIView()

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
}

final class BooksListViewController: UIViewController {
    private let tableview = UITableView(frame: .zero, style: .plain)
    private let category: Category
    private var presenter: BooksListPresenter!
    private var books: [Book] = []

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
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableview.tableFooterView = UIView()
        tableview.separatorInset = UIEdgeInsets()
        tableview.dataSource = self
        tableview.delegate = self
        tableview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableview)

        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension BooksListViewController: BooksListView {
    func showLoading() {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.center = tableview.center
        indicator.hidesWhenStopped = true

        let view = UIView()
        view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            indicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        ])

        tableview.tableFooterView = view
        indicator.startAnimating()
    }

    func hideLoading() {
        tableview.tableFooterView = UIView()
    }

    func display(_ books: [Book]) {
        self.books = books
        tableview.reloadData()
    }

    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension BooksListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let book = books[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = "\(book.title)"
        cell.selectionStyle = .none
        return cell
    }
}

extension BooksListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
