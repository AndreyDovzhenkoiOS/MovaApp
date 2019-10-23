//
//  UIAlertExtension.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/23/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension UIAlertController {

    static func showAlertController(_ message: String) -> UIAlertController {
        return alertController(title: Localized.Alert.title,
                               message: message,
                               titleAction: Localized.Alert.action)
    }

    static fileprivate func alertController(title: String, message: String,
                                            titleAction: String,
                                            completion: VoidCallback? = nil) -> UIAlertController {

        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: titleAction, style: .default, handler: { _ in
            guard let completionHandler = completion else { return }
            completionHandler()
        }))

        return alertController
    }

}
