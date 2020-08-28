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
        
        if I.mac {
            return text
        }
        
        // Adding font and background color that support dark mode
        let attributes: [NSAttributedString.Key: UIColor] = [.backgroundColor: .clear,
                                                             .foregroundColor: .label]
        
        text.addAttributes(attributes, range: NSRange(location: 0, length: text.length))
        
        text.enumerateAttribute(.attachment,
                                in: NSRange(location: 0, length: text.length),
                                options: .init(rawValue: 0),
                                using: { (value, range, _) in
                                    
                                    if let attachement = value as? NSTextAttachment {
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
                                })
        
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
