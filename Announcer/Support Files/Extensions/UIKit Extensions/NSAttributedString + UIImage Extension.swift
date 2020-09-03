//
//  NSAttributedString + UIImage Extension.swift
//  Announcer
//
//  Created by JiaChen(: on 26/8/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit
import CoreText

extension NSAttributedString {
    func resizedImages(with maxWidth: CGFloat) -> NSMutableAttributedString {
        let text = NSMutableAttributedString(attributedString: self)
        
        // Adding font and background color that support dark mode
        let attributes: [NSAttributedString.Key: UIColor] = [.backgroundColor: .clear]
        
        text.addAttributes(attributes, range: NSRange(location: 0, length: text.length))
        
        text.enumerateAttributes(in: NSRange(location: 0, length: text.length),
                                 options: .init(rawValue: 0)) { (attribute, range, _) in
            
            let attachmentAttr = attribute.filter {
                $0.value is NSTextAttachment
            }.last
            
            let foregroundAttr = attribute.filter {
                $0.key == .foregroundColor
            }.last
            
            if !I.mac, let attachement = attachmentAttr?.value as? NSTextAttachment {
                let image = attachement.image(forBounds: attachement.bounds,
                                              textContainer: NSTextContainer(),
                                              characterIndex: range.location)!
                
                if image.size.width > maxWidth {
                    
                    let newImage = image.resizeImage(scale: maxWidth / image.size.width)
                    
                    let newAttribut = NSTextAttachment()
                    
                    newAttribut.image = newImage
                    
                    text.addAttribute(.attachment, value: newAttribut, range: range)
                }
            }
            
            if let color = foregroundAttr?.value as? UIColor {
                var (red, green, blue, alpha) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
                
                color.getRed(&red,
                             green: &green,
                             blue: &blue,
                             alpha: &alpha)
                
                var newColor = UIColor.label
                
                if red > 0.7 && green < 0.5 && blue < 0.5 {
                    // Red
                    newColor = UIColor(named: "Text Red")!
                    
                } else if red < 0.5 && green < 0.5 && blue > 0.5 {
                    // Blue
                    newColor = UIColor(named: "Text Blue")!
                    
                } else if red > 0.7 && green > 0.7 && blue > 0.7 {
                    // Black/dark grey
                    newColor = UIColor.systemBackground
                }
                
                text.addAttribute(.foregroundColor, value: newColor, range: range)
            }
        }
        
        return text
    }
}

extension UIImage {
    func resizeImage(scale: CGFloat) -> UIImage {
        let newSize = CGSize(width: self.size.width*scale, height: self.size.height*scale)
        let rect = CGRect(origin: CGPoint.zero, size: newSize)
        
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
