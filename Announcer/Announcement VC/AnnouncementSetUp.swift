//
//  AnnouncementWhatsNew.swift
//  Announcer
//
//  Created by JiaChen(: on 26/8/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import WhatsNewKit
import UIKit

extension AnnouncementsViewController {
    
    /// Set up navigation controller, feedback button and preset whats new if needed
    func setUp() {
        setUpNavigationController()
        setUpFeedbackButton()
        whatsNew()
    }
    
    func whatsNew() {
        // Initialize WhatsNewVersionStore
        let versionStore: WhatsNewVersionStore = KeyValueWhatsNewVersionStore()

        let versionNumber = UserDefaults.standard.string(forKey: UserDefaultsIdentifiers.versionNumber.rawValue) ?? ""
        // Initialize WhatsNew
        let whatsNew = WhatsNew(
            // The Title
            title: "Announcer \(versionNumber)",
            
            // The features you want to showcase
            items: [
                WhatsNew.Item(title: "🎂 Happy 7th Birthday!!",
                              subtitle: "Celebrating 7 years of a… sort of working app! I'm honestly surprised we made it this far.",
                              image: UIImage(systemName: "smiley")),
                WhatsNew.Item(
                    title: "🕐 Announcer Timetables",
                    subtitle: "Find out what lessons are next and when it will be with Announcer Timetables.",
                    image: UIImage(systemName: "table")
                ),
                WhatsNew.Item(
                    title: "📢 Latest Announcements",
                    subtitle: "Check out the latest announcements from the home screen using the new widget.",
                    image: UIImage(systemName: "mail.stack") ?? UIImage(systemName: "rectangle.stack")
                ),
                WhatsNew.Item(
                    title: "🕵️‍♂️ Smarter Search",
                    subtitle: "The new Announcer search prioritises results based on the relevance of the posts to your search!",
                    image: UIImage(systemName: "magnifyingglass")
                )
//                WhatsNew.Item(
//                    title: "Announcer MacOS",
//                    subtitle: "SST Announcer is now available on the Mac! (requires macOS Big Sur and up)",
//                    image: UIImage(systemName: "macwindow")
//                )
            ]
        )
        
        var config = WhatsNewViewController.Configuration()
        
        config.detailButton = WhatsNewViewController.DetailButton(
            title: "Read More",
            action: .website(url: "https://github.com/sst-inc/sst-announcer-ios")
        )
        
        // Initialize CompletionButton with title and dismiss action
        config.completionButton = WhatsNewViewController.CompletionButton(
            title: "Continue",
            action: .dismiss
        )
        
        config.titleView.secondaryColor = .init(
            // The start index
            startIndex: 0,
            // The length of characters
            length: 9,
            // The secondary color to apply
            color: .systemBlue
        )
        
        // Passing a WhatsNewVersionStore to the initializer
        // will give you an optional WhatsNewViewController
        
        let whatsNewViewController: WhatsNewViewController? = WhatsNewViewController(
            whatsNew: whatsNew,
            configuration: config,
            versionStore: versionStore
        )
        
        // Verify WhatsNewViewController is available
        guard let viewController = whatsNewViewController else {
            // The user has already seen the WhatsNew-Screen for the current Version of your app
            return
        }

        // Present WhatsNewViewController
        self.present(viewController, animated: true)
    }
    
    func setUpNavigationController() {
        // Set up navigation buttons
        
        // - Corner radius for top buttons
        //   - This is for the scroll selection
        filterButton.layer.cornerRadius = 25 / 2
        reloadButton.tintColor = GlobalColors.greyOne
        
        // - Pointer support
        //   - Add a circle when they hover over button
        if #available(iOS 13.4, *) {
            filterButton.addInteraction(UIPointerInteraction(delegate: self))
        }
        
        // - Timetable is only supported on iOS 14
        if #available(iOS 14, macOS 11, *) {
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
        
        // Set up for macOS
        if I.mac {
            view.backgroundColor = .clear
            announcementTableView.backgroundColor = .clear
        }
        
        // Set up navigation controller appearance
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backIndicatorImage = UIImage(systemName: "arrow.uturn.left")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(systemName: "arrow.uturn.left")
        
        // Set title
        title = NSLocalizedString("APP_NAME",
                                  comment: "Announcer")
    }
    
    /// Set up announcer feedback button
    func setUpFeedbackButton() {
        let feedback = FeedbackButton(frame: .zero)
        
        feedback.translatesAutoresizingMaskIntoConstraints = false

        let feedbackConstraints = [NSLayoutConstraint(item: feedback,
                                                      attribute: .trailing,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .trailing,
                                                      multiplier: 1,
                                                      constant: -20),
                                   NSLayoutConstraint(item: feedback,
                                                      attribute: .bottom,
                                                      relatedBy: .equal,
                                                      toItem: view,
                                                      attribute: .bottomMargin,
                                                      multiplier: 1,
                                                      constant: -20),
                                   NSLayoutConstraint(item: feedback,
                                                      attribute: .height,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: 50)]
        
        feedback.parent = self
        
        view.addSubview(feedback)
        view.addConstraints(feedbackConstraints)
        
        self.feedback = feedback
    }
}
