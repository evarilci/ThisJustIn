//
//  OfflineDetailVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 15.07.2023.
//

import UIKit
import Kingfisher
import Toast


 class DetailViewController: UIViewController {
    // MARK: UI PROPERTIES
    
    var article : SavedArticle
    
    init(article: SavedArticle) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   private lazy var articleImage: UIImageView = {
        let iv = UIImageView()
       iv.contentMode = .scaleAspectFill
       iv.clipsToBounds = true
        return iv
    }()
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        return label
    }()
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .systemIndigo
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    
    // MARK: LIFECYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    
    // MARK: CONFIGURE UI METHODS
    private func setupUI() {
        view.backgroundColor = .systemGray6
        view.addSubview(articleImage)
        view.addSubview(titleLabel)
        view.addSubview(contentLabel)
        view.addSubview(sourceLabel)
        
        articleImage.snp.makeConstraints { make in
            make.top.equalToSuperview { view in
                view.safeAreaLayoutGuide
            }
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalToSuperview().dividedBy(3)
        }
        articleImage.image = article.image
        articleImage.layer.cornerRadius = 24
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(articleImage.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-24)
            make.height.equalTo(75)
        }
        titleLabel.text = article.title
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        contentLabel.text = article.description
        
        sourceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(24)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
            make.width.equalToSuperview().dividedBy(2)
        }
        sourceLabel.text = article.source
    }
}

// MARK: CoreDataReachable
extension DetailViewController: CoreDataReachable {}

