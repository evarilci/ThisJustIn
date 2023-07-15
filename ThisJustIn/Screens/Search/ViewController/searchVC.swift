//
//  searchVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 15.07.2023.
//

import UIKit
import SafariServices

final class SearchVC: UIViewController {
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = (self.view.frame.height / 3) - 48
        tv.backgroundColor = .systemGray6
        tv.separatorStyle = .none
        tv.register(HomeViewCell.self, forCellReuseIdentifier: K.cellIdentifier)
        return tv
    }()
    lazy var searchBar : UISearchBar = {
        let searchBar : UISearchBar = UISearchBar()
        searchBar.frame = CGRect(x: 0, y: 0, width: 200, height: 70)
        searchBar.delegate = self
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.placeholder = " Search"
        searchBar.sizeToFit()
        self.tableView.tableHeaderView = searchBar
        return searchBar
    }()
    let viewModel = SearchViewModel()
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupUI()
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
    func showArticle(url: URL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
    }
}

extension SearchVC: SearchViewModelDelegate {
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchArticlesFailed(error: TJIError) {
        
    }
    
    
}
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier) as! HomeViewCell
        let article = viewModel.articleFor(row: indexPath.row)
        cell.configureConteiner(with: article)
        cell.saveAction = {
            self.saveArticleToBookmarks(source: article.source?.name ?? "", title: article.title ?? "", content: article.content ?? "", url: article.url ?? "", image: article.urlToImage ?? "") { message in
                self.showToast(subtitle: message)
            }
        }
        cell.readAction = {
            let article = self.viewModel.articleFor(row: indexPath.row)
                    guard let url = URL(string:article.url!) else {return}
            self.showArticle(url: url)
        }
        return cell
    }
}

extension SearchVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        viewModel.searchArticles(with: searchText)
    }
}

