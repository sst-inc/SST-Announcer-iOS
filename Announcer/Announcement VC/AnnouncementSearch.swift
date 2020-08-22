//
//  Search.swift
//  Announcer
//
//  Created by JiaChen(: on 19/8/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

struct AnnouncementSearch {
    var titles: [Post]?
    var contents: [Post]?
    var labels: [Post]? {
        didSet {
            labelsDidSet()
        }
    }
    
    var labelsDidSet: (() -> Void)
}

extension UISearchBar {
    func addInputAccessoryView(title: String, target: Any?, selector: Selector?) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        
        let predictive1 = UIBarButtonItem(title: "Hey", style: .plain, target: target, action: selector)
        let predictive2 = UIBarButtonItem(title: "Hi", style: .plain, target: target, action: selector)
        let predictive3 = UIBarButtonItem(title: "Hello", style: .plain, target: target, action: selector)
        
        toolBar.barTintColor = .systemBlue
        
        let items = [predictive1, predictive2, predictive3, flexible, barButton]
        
        for i in items {
            i.tintColor = .systemBackground
        }
        
        toolBar.setItems(items, animated: false)
        
        self.inputAccessoryView = toolBar
    }
}
