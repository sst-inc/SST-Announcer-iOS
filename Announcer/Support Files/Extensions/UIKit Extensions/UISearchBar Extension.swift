//
//  UISearchBar Extension.swift
//  Announcer
//
//  Created by JiaChen(: on 21/4/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension UISearchBar {
    
    /// Get the textField in the search bar
    func getTextField() -> UITextField? {
        return value(forKey: "searchField") as? UITextField
    }
    
    /// Setting the search text color for the search bar
    func set(textColor: UIColor) {
        if let textField = getTextField() {
            textField.textColor = textColor
        }
    }
    
    /// Setting the placeholder text color for search bar
    func setPlaceholder(textColor: UIColor) {
        getTextField()?.setPlaceholder(textColor: textColor)
    }
    
    /// Setting the clear button color for search bar
    func setClearButton(color: UIColor) {
        getTextField()?.setClearButton(color: color)
    }
    
    /// Set background color for search bar text field
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else {
            return
        }
        
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default:
            textField.backgroundColor = color
            
        @unknown default:
            break
        }
    }
    
    /// Set search image color for search bar
    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else {
            return
        }
        
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}
