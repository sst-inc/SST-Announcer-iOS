//
//  UIColor Extension.swift
//  Announcer
//
//  Created by JiaChen(: on 21/4/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    /// Add multiple colors together with +
    static func + (color1: UIColor, color2: UIColor) -> UIColor {
        var (redOne, greenOne, blueOne, alphaOne) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (redTwo, greenTwo, blueTwo, alphaTwo) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        color1.getRed(&redOne,
                      green: &greenOne,
                      blue: &blueOne,
                      alpha: &alphaOne)
        
        color2.getRed(&redTwo,
                      green: &greenTwo,
                      blue: &blueTwo,
                      alpha: &alphaTwo)

        // add the components, but don't let them go above 1.0
        return UIColor(red: min(redOne + redTwo, 1),
                       green: min(greenOne + greenTwo, 1),
                       blue: min(blueOne + blueTwo, 1),
                       alpha: (alphaOne + alphaTwo) / 2)
    }

    /// Multiply a color by a `CGFloat` from 0 to 1
    static func * (color: UIColor, multiplier: CGFloat) -> UIColor {
        var (red, green, blue, alpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return UIColor(red: red * CGFloat(multiplier),
                       green: green * CGFloat(multiplier),
                       blue: blue * CGFloat(multiplier),
                       alpha: alpha)
    }
}
