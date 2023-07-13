//
//  TabBarVC.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 13.07.2023.
//


import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
       
    }
    
    private func templateNavController(selectedImage: UIImage, unselectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage.withRenderingMode(.alwaysOriginal)
        nav.tabBarItem.selectedImage? = selectedImage.withRenderingMode(.alwaysOriginal)
   //     nav.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
        nav.tabBarController?.tabBar.itemPositioning = .centered
        tabBar.backgroundColor = .systemGray6
        tabBar.barTintColor = .systemGray6
        return nav
    }
    
    func setupViewControllers() {
        
        viewControllers = [templateNavController(selectedImage: UIImage(systemName: "house.fill")!, unselectedImage: UIImage(systemName: "house")!, rootViewController: HomeVC()),
                           templateNavController(selectedImage: UIImage(systemName: "bookmark.fill")!, unselectedImage: UIImage(systemName: "bookmark")!, rootViewController: BookmarksVC()),
                           
                           ]
    }
}

