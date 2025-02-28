//
//  BooksListViewController.swift
//  NYT Bestsellers
//
//  Created by Sylvan Ash on 20/12/2024.
//

import UIKit

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
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

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
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
        let identifier = (indexPath.row == 0) ? String(describing: CardViewCell.self) : String(describing: BookViewCell.self)

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? ConfigurableBookCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: book)

        return cell
    }
}

extension BooksListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let controller = BookDetailsViewController(book: book)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension BooksListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12

        if indexPath.row == 0 {
            let width = view.bounds.width - (2 * spacing)
            return CGSize(width: width, height: CardViewCell.getViewHeight())
        }

        let numberOfColumns: CGFloat = 3
        let totalSpacing = (numberOfColumns - 1) * 2
        let availableWidth = view.bounds.width - (totalSpacing + (2 * spacing) + (2 * 10))
        let cellWidth = floor(availableWidth / numberOfColumns)

        return CGSize(width: cellWidth, height: BookViewCell.getViewHeight())
    }
}
