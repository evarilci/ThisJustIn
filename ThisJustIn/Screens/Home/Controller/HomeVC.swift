//
//  HomeVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//

import UIKit
import SafariServices

final class HomeVC: UIViewController {
    // MARK: - Properties
  
   lazy var refreshControl : UIRefreshControl = {
       let refresh = UIRefreshControl()
       refresh.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
      return refresh
    }()
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
    let viewModel = HomeViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        viewModel.viewDidLoad()
    }
    
    
    func setupUI() {
          let splashView = SplashScreen()
          let barView = BarView()
        view.addSubview(splashView)
        splashView.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
        splashView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {[weak self] in
            guard let self else {return}
            self.navigationController?.isNavigationBarHidden = false
            splashView.snp.removeConstraints()
            splashView.isHidden = true
            
            self.view.addSubview(self.tableView)
            self.navigationItem.titleView = barView
            self.view.backgroundColor = .systemGray6
            self.tableView.snp.makeConstraints { make in
                make.leading.trailing.bottom.equalToSuperview()
                make.top.equalToSuperview { view in
                    view.safeAreaLayoutGuide
                }
            }
        }
    )}
    
    @objc func refreshAction() {
        viewModel.viewDidLoad()
        refreshControl.endRefreshing()
    }
}
// MARK: - UITableViewDelegate, UITableViewDataSource


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! HomeViewCell
        cell.selectionStyle = .none
        
        let article = viewModel.articleFor(row: indexPath.row)
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
        
        cell.configureConteiner(with: article)
        return cell
    }
}
// MARK: - HomeViewModelDelegate

extension HomeVC: HomeViewModelDelegate {
    func fetchArticlesSucceed(article: Response) {
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
