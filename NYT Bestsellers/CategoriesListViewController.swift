//
//  CategoriesListViewController.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 11/12/2024.
//

import UIKit

final class CategoriesListViewController: UIViewController {
    private let tableview = UITableView(frame: .zero, style: .plain)
    private var presenter: CategoriesListPresenter!
    private var categories = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSubviews()

        presenter = CategoriesListPresenter(view: self)
        presenter.fetchCategories()
    }
}

private extension CategoriesListViewController {
    func setupNavigationBar() {
        navigationItem.title = "Books Categories"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setupSubviews() {
        view.backgroundColor = .white

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

extension CategoriesListViewController: CategoriesListView {
    func showLoading() {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.center = tableview.center
        indicator.hidesWhenStopped = true
        tableview.tableFooterView = indicator
        indicator.startAnimating()
    }
    
    func hideLoading() {
        tableview.tableFooterView = UIView()
    }
    
    func display(_ categories: [Category]) {
        self.categories = categories
        tableview.reloadData()
    }
    
    func displayError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension CategoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = "\(category.name)"
        cell.selectionStyle = .none
        return cell
    }
}

extension CategoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let controller = BooksListViewController(category: category)
        navigationController?.pushViewController(controller, animated: true)
    }
}
