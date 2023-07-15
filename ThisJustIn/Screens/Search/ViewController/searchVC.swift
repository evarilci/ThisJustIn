//
//  searchVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 15.07.2023.
//

import UIKit
import SafariServices

final class SearchVC: UIViewController, CoreDataReachable {
    lazy var refreshControl : UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
       return refresh
     }()
    let searchController = UISearchController(searchResultsController: nil)
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.refreshControl = self.refreshControl
        tv.rowHeight = (self.view.frame.height / 3) - 48
        tv.backgroundColor = .systemGray6
        tv.separatorStyle = .none
        tv.register(HomeViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        return tv
    }()
    let viewModel = SearchViewModel()
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
    func setupUI() {
        view.addSubview(tableView)
        view.backgroundColor = .systemGray6
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview { view in
                view.safeAreaLayoutGuide
            }
        }
    }
    @objc func refreshAction() {
        let searchbar = searchController.searchBar
        let scopeButton = searchbar.scopeButtonTitles![searchbar.selectedScopeButtonIndex]
        Task {
            try? await viewModel.getArticles(category: scopeButton)
        }
        refreshControl.endRefreshing()
    }
    
    private func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.showsScopeBar = true
        searchController.searchBar.scopeButtonTitles = ["general","technology","Bussines","sports","science","health","entertainment"]
        definesPresentationContext = true
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = " Search"
    }
}

// MARK: - SearchViewModelDelegate
extension SearchVC: SearchViewModelDelegate {
    func isSearching(bool: Bool) {
        
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func fetchArticlesFailed(error: TJIError) {
        switch error {
        case .invalidURL:
            print("invalid url")
        case .badResponse:
            print("invalid response")
        case .invalidData:
            print("invalid data")
        default:
            print("Another error")
        }
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(viewModel.getArticleCount(), "number of rows")
        return viewModel.getArticleCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as! HomeViewCell
        let article = viewModel.getArticle(at: indexPath.row)
        print(article.title!, "title")
        cell.configureConteiner(with: article)
        cell.saveAction = {
            self.saveArticleToBookmarks(source: article.source?.name ?? "", title: article.title ?? "", content: article.content ?? "", url: article.url ?? "", image: article.urlToImage ?? "") { message in
                self.showToast(subtitle: message)
            }
        }
        cell.readAction = {
            let article = self.viewModel.getArticle(at: indexPath.row)
            guard let url = URL(string:article.url!) else {return}
            self.showArticle(url: url)
        }
        return cell
    }
}

// MARK: - UISearchResultsUpdating, UISearchBarDelegate
extension SearchVC: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
        let searchbar = searchController.searchBar
        let scopeButton = searchbar.scopeButtonTitles![searchbar.selectedScopeButtonIndex]
        print(scopeButton, "scopeButton")
        Task {
            try? await viewModel.getArticles(category: scopeButton)
        }
        self.tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            viewModel.filterArticles(with: searchText)
        } else {
            viewModel.filteredArticles = viewModel.articles
            viewModel.cancelFiltering()
        }
    }
}
