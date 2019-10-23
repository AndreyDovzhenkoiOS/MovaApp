//
//  CALayer.swift
//  MovaApp
//
//  Created by Andrey Dovzhenko on 10/23/19.
//  Copyright © 2019 Andrey Dovzhenko. All rights reserved.
//

import UIKit

extension CALayer {
    func setupShadow(radius: CGFloat, opacity: Float, height: CGFloat) {
        shouldRasterize = true
        rasterizationScale = UIScreen.main.scale
        masksToBounds = false
        shadowRadius = radius
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 0, height: height)
        shadowOpacity = opacity
    }
}
