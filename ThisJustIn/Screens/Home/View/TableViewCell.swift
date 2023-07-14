//
//  TableViewCell.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//

import UIKit


final class HomeViewCell: UITableViewCell {
    
    var saveAction : (() -> Void)?
    var readAction : (() -> Void)?
     lazy var button : UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "bookmark.fill")!.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        btn.setImage(UIImage(systemName: "bookmark.fill")!.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        btn.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var KeepReedButton : UIButton = {
       let btn = UIButton()
        btn.setTitle("Keep reading", for: .normal)
        btn.setTitleColor(.link, for: .normal)
        btn.setImage(UIImage(systemName: "chevron.right")!.withTintColor(.link, renderingMode: .alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(tapHandle), for: .touchUpInside)
        btn.semanticContentAttribute = .forceRightToLeft
        return btn
    }()
    
    @objc func bookmarkButtonTapped() {
        saveAction?()
    }
    
    @objc func tapHandle() {
        readAction?()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureConteiner(with artical: Article) {
        guard let title = artical.title else {return}
        guard let urlString = artical.urlToImage else {return}
        guard let url = URL(string: urlString) else {return}
        guard let content = artical.content else {return}
        lazy var container = CellContainerView(title: title, imageURL: url, content: content)
        
        container.layer.cornerRadius = self.frame.height / 2
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        contentView.addSubview(button)
        button.snp.makeConstraints {make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.width.equalTo(50)
        }
        contentView.addSubview(KeepReedButton)
        KeepReedButton.snp.makeConstraints { make in
            make.trailing.equalTo(container.snp.trailing).offset(-8)
            make.bottom.equalTo(container.snp.bottom).offset(-8)
            make.width.equalTo(150)
            make.height.equalTo(10)
        }
        
    }
    
    func configureConteiner(with artical: SavedArticle) {
        guard let title = artical.title, let content = artical.description, let _ = artical.source else {return}
        let image = artical.image
        lazy var container = CellContainerView(title: title, content: content, image: image)
        
        container.layer.cornerRadius = self.frame.height / 2
        contentView.addSubview(container)
        container.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    
        contentView.addSubview(KeepReedButton)
        KeepReedButton.snp.makeConstraints { make in
            make.trailing.equalTo(container.snp.trailing).offset(-8)
            make.bottom.equalTo(container.snp.bottom).offset(-8)
            make.width.equalTo(150)
            make.height.equalTo(10)
        }
        
    }
    
}
