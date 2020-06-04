//
//  LoadingViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 4/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    var loadingIndicator: UIActivityIndicatorView!
    
    override func loadView() {
        super.loadView()
        
        let loadingIndicator = UIActivityIndicatorView()
        
        loadingIndicator.style = .large
        
        loadingIndicator.hidesWhenStopped = true
        
        loadingIndicator.startAnimating()
        
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([NSLayoutConstraint(item: loadingIndicator,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .centerX,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: loadingIndicator,
                                                attribute: .centerY,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .centerY,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: loadingIndicator,
                                                attribute: .width,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 40),
                             NSLayoutConstraint(item: loadingIndicator,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 40)
        ])
        
        view.addSubview(loadingIndicator)
        view.backgroundColor = GlobalColors.background
        
        self.loadingIndicator = loadingIndicator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
