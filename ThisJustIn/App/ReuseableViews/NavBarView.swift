//
//  NavBarView.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 15.07.2023.
//


import UIKit

final class BarView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let imageView = UIImageView()
        imageView.image =  UIImage(named: K.logo)!
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(50)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


