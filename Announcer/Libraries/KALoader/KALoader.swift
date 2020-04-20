//
//  KALoader.swift
//  KALoader
//
//  Created by Kirill Averyanov on 08/09/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import Foundation
import UIKit

internal class KALoaderView: UIView {
    /// Constants
    private let gradientWidth: CGFloat = 0.2
    private let gradientStop: CGFloat = 0.1
    private let backGrayColor = UIColor(named: "Back Gray Color")!
    private let firstLoadColor = UIColor(named: "First Load Color")!
    private let secondLoadColor = UIColor(named: "Second Load Color")!
    private let fillMode: String = CAMediaTimingFillMode.forwards.rawValue
    private var gradientAnimationDuration: TimeInterval = 0.7
    private var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.colors = [backGrayColor.cgColor, firstLoadColor.cgColor,
                                secondLoadColor.cgColor, firstLoadColor.cgColor, backGrayColor.cgColor]
        gradientLayer.locations = [0, 0, 0,
                                   NSNumber(value: Double(gradientWidth)),
                                   NSNumber(value: Double(1 + gradientWidth))]
        
        gradientLayer.frame = frame
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFrameForGradientLayer(frame: CGRect) {
        gradientLayer.frame = frame
    }
    
    func setCustom(colors: [UIColor], gradientAnimationDuration: TimeInterval) {
        if colors.count != 5 {
            assertionFailure("You should send 5 colors in colors array")
        }
        var cgColors = [CGColor]()
        colors.forEach({ cgColors.append($0.cgColor) })
        self.gradientLayer.colors = cgColors
        self.gradientAnimationDuration = gradientAnimationDuration
    }
    
    func startAnimateLayer() {
        let gradientAnimation = CABasicAnimation(keyPath: "locations")
        gradientAnimation.fromValue = gradientLayer.locations
        gradientAnimation.toValue = [0, 1, 1,
                                     NSNumber(value: Double(1 + (gradientWidth - gradientStop))),
                                     NSNumber(value: Double(1 + gradientWidth))]
        gradientAnimation.duration = gradientAnimationDuration
        gradientAnimation.fillMode = CAMediaTimingFillMode(rawValue: fillMode)
        gradientAnimation.repeatCount = .infinity
        gradientLayer.add(gradientAnimation, forKey: nil)
    }
    
    func stopAnimateLayer() {
        gradientLayer.removeAllAnimations()
    }
}
