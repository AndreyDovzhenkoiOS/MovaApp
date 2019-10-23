//
//  UIViewControllerExtension.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/23/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension UIViewController {
    func present(on viewController: UIViewController) {
        present(viewController, animated: true, completion: nil)
    }

    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
