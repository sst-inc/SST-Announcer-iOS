//
//  ContentPreviewing.swift
//  Announcer
//
//  Created by JiaChen(: on 6/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension ContentViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        if let cell = interaction.view as? LinksCollectionViewCell {
            let safariVC = SFSafariViewController(url: URL(string: cell.link.link)!)
            
            let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in // menu elements from responder chain if any
                
                let openLink = UIAction(title: "Open Link",
                                        image: Assets.safari,
                                        identifier: nil,
                                        discoverabilityTitle: nil,
                                        attributes: [],
                                        state: .off) { (_) in
                                            // Open link
                                            self.present(safariVC, animated: true)
                }
                
                let copyLink = UIAction(title: "Copy Link",
                                        image: Assets.copy,
                                        identifier: nil,
                                        discoverabilityTitle: nil,
                                        attributes: [],
                                        state: .off) { (_) in
                                            // Copy link
                                            UIPasteboard.general.string = cell.link.link
                }
                
                let share = UIAction(title: "Share...",
                                     image: Assets.share,
                                     identifier: nil,
                                     discoverabilityTitle: nil,
                                     attributes: [],
                                     state: .off) { (_) in
                                        //Create Activity View Controller (Share screen)
                                        let shareViewController = UIActivityViewController.init(activityItems: [URL(string: cell.link.link)!], applicationActivities: nil)
                                        
                                        //Remove unneeded actions
                                        shareViewController.excludedActivityTypes = [.saveToCameraRoll]
                                        
                                        //Present share sheet
                                        shareViewController.popoverPresentationController?.sourceView = cell
                                        
                                        self.present(shareViewController, animated: true, completion: nil)
                }
                
                
                return UIMenu(title: "",
                              image: nil,
                              identifier: nil,
                              options: [],
                              children: [openLink, copyLink, share])
            }
            
            return UIContextMenuConfiguration(identifier: GlobalIdentifier.openPostPreview,
                                              previewProvider: { () -> UIViewController? in
                                                return safariVC
            },
                                              actionProvider: actionProvider)
        } else if let cell = interaction.view as? CategoriesCollectionViewCell {
            let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in // menu elements from responder chain if any
                
                let openLink = UIAction(title: "Filter Posts",
                                        image: Assets.safari,
                                        identifier: nil,
                                        discoverabilityTitle: nil,
                                        attributes: [],
                                        state: .off) { (_) in
                                            print("sure")
                }
                
                let copyFilter = UIAction(title: "Copy Filter",
                                          image: Assets.copy,
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          attributes: [],
                                          state: .off) { (_) in
                                            // Copy filter
                                            UIPasteboard.general.string = cell.titleLabel.text!
                }
                
                return UIMenu(title: "",
                              image: nil,
                              identifier: nil,
                              options: [],
                              children: [openLink, copyFilter])
            }
            
            return UIContextMenuConfiguration(identifier: GlobalIdentifier.openPostPreview,
                                              previewProvider: nil,
                                              actionProvider: actionProvider)
        }
        
        return nil
    }
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
    }
}
