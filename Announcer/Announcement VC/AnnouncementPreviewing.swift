//
//  AnnouncementPreviewing.swift
//  Announcer
//
//  Created by JiaChen(: on 13/12/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension AnnouncementsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = announcementTableView.indexPathForRow(at: location) {
            previewingContext.sourceRect = announcementTableView.rectForRow(at: indexPath)
            return getContentViewController(for: indexPath)
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    func getContentViewController(for indexPath: IndexPath) -> ContentViewController {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "detail") as? ContentViewController else {
            fatalError()
        }
        let cell = announcementTableView.cellForRow(at: indexPath) as! AnnouncementTableViewCell
        
        selectedItem = cell.post
        
        vc.post = selectedItem
        vc.onDismiss = {
            DispatchQueue.main.async {
                self.announcementTableView.reloadData()
                self.reload(UILabel())
            }
            
        }
        
        return vc
    }
}

@available(iOS 13.0, *)
extension AnnouncementsViewController: UIContextMenuInteractionDelegate {
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in // menu elements from responder chain if any
            // Creating actions…
            let cell = interaction.view as! AnnouncementTableViewCell
            var pinned = self.pinned.contains(cell.post)
                
            
            let pin = UIAction(title: {
                pinned ? "Unpin" : "Pin"
            }(),
                                       image: {
                                           pinned ? UIImage(systemName: "pin.fill")! : UIImage(systemName: "pin")!
                                       }(),
                                       identifier: nil,
                                       discoverabilityTitle: nil,
                                       attributes: [],
                                       state: .off) { (_) in
                                        print("tapped")
                                        
                                        var pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
                                        
                                        if pinned {
                                            pinnedItems.remove(at: pinnedItems.firstIndex(of: cell.post)!)
                                        } else {
                                            pinnedItems.append(cell.post)
                                        }
                                        
                                        PinnedAnnouncements.saveToFile(posts: pinnedItems)
                                        self.pinned = PinnedAnnouncements.loadFromFile() ?? []
                                        self.announcementTableView.reloadData()
            }
            
            let share = UIAction(title: "Share",
                                             image: UIImage(systemName: "square.and.arrow.up"),
                                             identifier: nil,
                                             discoverabilityTitle: nil,
                                             attributes: [],
                                             state: .off) { (_) in
                                                let shareText = cell.post.content.htmlToString
                                                
                                                //Create Activity View Controller (Share screen)
                                                let shareViewController = UIActivityViewController.init(activityItems: [shareText], applicationActivities: nil)
                                                
                                                //Remove unneeded actions
                                                shareViewController.excludedActivityTypes = [.saveToCameraRoll, .addToReadingList]
                                                
                                                //Present share sheet
                                                shareViewController.popoverPresentationController?.sourceView = self.view
                                                self.present(shareViewController, animated: true, completion: nil)

            }
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: [],
                          children: [pin, share])
        }
        return UIContextMenuConfiguration(identifier: "my identifier" as NSCopying,
                                          previewProvider: nil,
                                          actionProvider: actionProvider)
    }
}
