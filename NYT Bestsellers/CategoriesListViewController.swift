//
//  CategoriesListViewController.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 11/12/2024.
//

import UIKit

class CategoriesListViewController: UIViewController {
    private let tableview = UITableView(frame: .zero, style: .plain)
    private let items = [1...10]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSubviews()
        loadData()
    }
}

private extension CategoriesListViewController {
    func setupNavigationBar() {
        navigationItem.title = "Books Categories"
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

    func loadData() {
        //
    }
}

extension CategoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        cell.textLabel?.text = "#\(indexPath.row)"
        return cell
    }
}

extension CategoriesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
