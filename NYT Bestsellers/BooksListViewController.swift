//
//  BooksListViewController.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 20/12/2024.
//

import UIKit

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
