//
//  ContentAlerts.swift
//  Announcer
//
//  Created by JiaChen(: on 30/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension ContentViewController {
    func postRequiresWebKit() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: ErrorMessages.postRequiresWebKit.title,
                                          message: ErrorMessages.postRequiresWebKit.description,
                                          preferredStyle: .alert)

            // Open post in safari, post requires webkit
            let openInSafari = UIAlertAction(title: "Open in Safari", style: .default, handler: { (_) in
                self.openPostInSafari(UILabel())
            })

            alert.addAction(openInSafari)

            // Set preferred action for macOS alerts
            alert.preferredAction = openInSafari

            // Close post
            alert.addAction(UIAlertAction(title: "Close Post", style: .cancel, handler: { (_) in
                if I.phone {
                    // Handling dismissing from Navigation Controller
                    self.navigationController?.popViewController(animated: true)

                    // Handling dismissing from Peek and Pop
                    self.dismiss(animated: true)
                }
            }))

            DispatchQueue.main.async {
                // Present alert
                self.present(alert, animated: true)
            }
        }
    }
}
