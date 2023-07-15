//
//  UIViewController+Extension.swift
//  ThisJustIn
//
//  Created by Eymen Varilci on 14.07.2023.
//

import UIKit
import Toast
import SafariServices

extension UIViewController {
    func showToast(subtitle: String) {
        let toast = Toast.default(
            image: UIImage(systemName: "checkmark.seal.fill")!,
            title: "Done!",
            subtitle: subtitle,
            config: .init(direction: .top, autoHide: true, enablePanToClose: true, displayTime: 3, animationTime: 0.2, enteringAnimation: .default, exitingAnimation: .default, attachTo: nil)
        )
        toast.show()
    }
    func showArticle(url: URL) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
    }
}
