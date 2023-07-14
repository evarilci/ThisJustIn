//
//  HomeVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//

import UIKit
import SafariServices

class HomeVC: UIViewController {
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
    let viewModel = HomeViewModel()
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

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! HomeViewCell
        cell.selectionStyle = .none
        
        let article = viewModel.articleFor(row: indexPath.row)
        cell.saveAction = {
            self.saveArticleToBookmarks(source: article.source?.name ?? "", title: article.title ?? "", content: article.description ?? "", url: article.url ?? "", image: article.urlToImage ?? "") { message in
                self.showToast(subtitle: message)
            }
        }
        cell.readAction = {
            let article = self.viewModel.articleFor(row: indexPath.row)
                    guard let url = URL(string:article.url!) else {return}
            self.showArticle(url: url)
        }
        
        cell.configureConteiner(with: article)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let article = viewModel.articleFor(row: indexPath.row)
//        guard let url = URL(string:article.url!) else {return}
//        showArticle(url: url)
//    }
}

extension HomeVC: HomeViewModelDelegate {
    func fetchArticlesSucceed(article: Response) {
        dump(article)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchArticlesFailed(error: TJIError) {
        switch error {
        case .badResponse:
            print("Bad Response")
        case .invalidData:
            print("data could not be decoded")
        case .invalidURL:
            print("invalid URL")
        default:
            break
        }
    }
}

extension HomeVC: SFSafariViewControllerDelegate, CoreDataReachable {
    
}
