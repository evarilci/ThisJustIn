//
//  CellContainerView.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//


import UIKit
import Kingfisher

final class CellContainerView: UIView {
    
    private lazy var articalImage: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .secondaryLabel
        label.numberOfLines = .zero
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    init(frame: CGRect = .zero, title: String, imageURL: URL, content: String) {
        super.init(frame: frame)
        configureUI(imageURL: imageURL, title: title, content: content)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(imageURL: URL, title: String, content: String) {
        addSubview(articalImage)
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        articalImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.equalToSuperview().offset(8)
            make.width.equalToSuperview().dividedBy(2).offset(-8)
            make.bottom.equalToSuperview().offset(-8)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.centerX).offset(8)
            make.top.equalTo(articalImage.snp.top)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.snp.centerX).offset(8)
            make.top.equalTo(titleLabel.snp.bottom).offset(-10)
            make.trailing.equalToSuperview().offset(-18)
            make.bottom.equalToSuperview().offset(-8)
        }
        self.backgroundColor = .systemGray4
        
        
        articalImage.kf.setImage(with: imageURL, placeholder: UIImage(systemName: "newspaper")!)
        DispatchQueue.main.async {
            self.articalImage.layer.cornerRadius = self.articalImage.frame.height / 10
        }
        
        titleLabel.text = title
        contentLabel.text = content
        self.backgroundColor = .systemGray6
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
