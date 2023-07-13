//
//  TableViewCell.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//

import UIKit


final class HomeViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //configureUI()
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
        addSubview(container)
        container.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().inset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().inset(8)
        }
        
    }
    
}
