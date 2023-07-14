//
//  BookmarksVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//




import UIKit
import WebKit


class BookmarksVC: UIViewController {
    private lazy var button : UIButton = {
       let btn = UIButton()
        btn.setTitle("Open web", for: .normal)
        return btn
    }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
     
   }
}
