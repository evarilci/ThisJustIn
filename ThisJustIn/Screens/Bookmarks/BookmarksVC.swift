//
//  BookmarksVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//




import UIKit
import WebKit


final class BookmarksVC: UIViewController, CoreDataReachable {
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
   
    var articles = [SavedArticle]() {
        didSet {
            self.tableView.reloadData()
        }
    }
   override func viewDidLoad() {
      super.viewDidLoad()
       do {
           self.articles = try fetchArticle()
       } catch {
           print(error.localizedDescription)
       }
   }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            self.articles = try fetchArticle()
        } catch {
            print(error.localizedDescription)
        }
        setupUI()
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
}

extension BookmarksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! HomeViewCell
        let article = articles[indexPath.row]
        cell.configureConteiner(with: article)
        cell.readAction = {
        let vc = DetailViewController(article: article)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return cell
    }
    
    
}


