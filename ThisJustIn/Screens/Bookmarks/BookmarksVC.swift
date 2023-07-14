//
//  BookmarksVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//




import UIKit
import WebKit


class BookmarksVC: UIViewController, WKNavigationDelegate {
    private lazy var button : UIButton = {
       let btn = UIButton()
        btn.setTitle("Open web", for: .normal)
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return btn
    }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
       let url = URL(string: "https://www.hackingwithswift.com")!
     
       
       
//       view.addSubview(button)
//       button.snp.makeConstraints { make in
//           make.center.equalToSuperview()
//           make.width.equalTo(200)
//           make.height.equalTo(100)
//       }
     
   }
    override func loadView() {
       
    }
    
    @objc func buttonTapped() {
      
       
       
       
        
    }
    
    
}


class WebVC: UIViewController, WKNavigationDelegate {
    
    var url : URL?
   
  
    private lazy var button : UIButton = {
       let btn = UIButton()
        btn.setTitle("Open web", for: .normal)
        btn.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return btn
    }()
    var webView: WKWebView!
    
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
   override func viewDidLoad() {
      super.viewDidLoad()
       DispatchQueue.main.async {
           let url = self.url
           self.webView.load(URLRequest(url: url!))
       }
      
       webView.allowsBackForwardNavigationGestures = true
       view.backgroundColor = .systemGray6
             
      
     
   }
   
    
    @objc func buttonTapped() {
      
    }
    
    
}
