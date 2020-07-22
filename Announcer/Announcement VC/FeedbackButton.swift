//
//  FeedbackButton.swift
//  Announcer
//
//  Created by JiaChen(: on 22/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import SafariServices

class FeedbackButton: UIView {

    let feedbackButton = UIImageView()
    var parent: UIViewController?
    
    var label: UILabel!
    var stack: UIStackView!
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUp()
    }
    
    func setUp() {
        let stack = UIStackView()
        let label = UILabel()
        let imageView = UIImageView()
        
        label.text = "Feedback"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = GlobalColors.blueTint
        
        let config = UIImage.SymbolConfiguration(font: UIFont.boldSystemFont(ofSize: 20), scale: .large)
        
        imageView.image = UIImage(systemName: "exclamationmark.bubble", withConfiguration: config)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = GlobalColors.blueTint
        
        stack.axis = .horizontal
        stack.spacing = 16
        
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(label)
        
        self.label = label
        self.stack = stack
        self.imageView = imageView
        
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let stackConstraints = [NSLayoutConstraint(item: stack,
                                                   attribute: .centerX,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerX,
                                                   multiplier: 1,
                                                   constant: 0),
                                NSLayoutConstraint(item: stack,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .centerY,
                                                   multiplier: 1,
                                                   constant: 0),
                                NSLayoutConstraint(item: stack,
                                                   attribute: .leading,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .leading,
                                                   multiplier: 1,
                                                   constant: 16),
                                NSLayoutConstraint(item: stack,
                                                   attribute: .top,
                                                   relatedBy: .equal,
                                                   toItem: self,
                                                   attribute: .top,
                                                   multiplier: 1,
                                                   constant: 16)
        ]
        
        addConstraints(stackConstraints)
        
        addSubview(stack)
        backgroundColor = .systemBackground
        layer.cornerRadius = 25
        
        layer.shadowColor = UIColor.black.withAlphaComponent(0.7).cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onClick))
        
        addGestureRecognizer(tap)
    }
    
    @objc func onClick() {
        let link = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSe-zFUjCBj2i0OZfQGpKDs3HQtjIU9cl_mbZCT03lPKDab25Q/viewform?usp=sf_link")!
        
        if I.mac {
            UIApplication.shared.open(link)
        } else {
            let svc = SFSafariViewController(url: link)
            
            parent?.present(svc, animated: true, completion: nil)
        }
    }
    
    func close() {
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.label.isHidden = true
        })
    }
    
    func open() {
        UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [.allowUserInteraction, .beginFromCurrentState], animations: {
            self.label.isHidden = false
        })
    }
}
