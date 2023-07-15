//
//  SplashView.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 15.07.2023.
//


import UIKit

final class SplashScreen: UIView {
    
    let splashImage : UIImageView = {
    let iv = UIImageView()
        iv.image = UIImage(named: K.logo)!.withRenderingMode(.alwaysOriginal)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func configureUI() {
        addSubview(splashImage)
      
        self.backgroundColor = .systemGray6
        splashImage.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().offset(-32)
            make.height.equalTo(splashImage.snp.width).dividedBy(16/9)
        
        }
    }
    
    
}

