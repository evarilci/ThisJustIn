//
//  HomeVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//

import UIKit

class HomeVC: UIViewController {
    lazy var tableView : UITableView = {
       let tv = UITableView()
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = (self.view.frame.height / 3) - 48
        tv.backgroundColor = .systemGray6
        tv.separatorStyle = .none
        return tv
    }()
    let viewModel = HomeViewModel()
    override func viewDidLoad()  {
        super.viewDidLoad()
        view.backgroundColor = .red
        viewModel.delegate = self
        Task {
            let response = try await viewModel.fetchArtical()
        }
    }
    func setupUI() {
   
        view.addSubview(tableView)
           
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalToSuperview { view in
                view.safeAreaLayoutGuide
            }
        }
    
       
    }

}


extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

extension HomeVC: HomeViewModelDelegate {
    func fetchArticalsSucceed(artical: Response) {
        dump(artical)
    }
    
    func fetchArticalsFailed(error: TJIError) {
        switch error {
        case .badResponse:
            print("Bad Response")
        case .invalidData:
            print("data could not be decoded")
        case .invalidURL:
            print("invalid URL")
        }
    }
    
    
}
