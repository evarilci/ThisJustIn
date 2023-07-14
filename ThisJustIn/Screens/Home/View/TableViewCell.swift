//
//  TableViewCell.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//

import UIKit


final class HomeViewCell: UITableViewCell {
    
    var action : (() -> Void)? 
     lazy var button : UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "bookmark.fill")!.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        btn.setImage(UIImage(systemName: "bookmark.fill")!.withTintColor(.red, renderingMode: .alwaysOriginal), for: .selected)
        btn.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return btn
    }()
    @objc func bookmarkButtonTapped() {
        action?()
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
        guard let content = artical.description else {return}
        lazy var container = CellContainerView(title: title, imageURL: url, content: content)
        container.layer.cornerRadius = self.frame.height / 2
        addSubview(container)
        container.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
       addSubview(button)
        button.snp.makeConstraints {make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.width.equalTo(50)
        }
        
    }
    
}
