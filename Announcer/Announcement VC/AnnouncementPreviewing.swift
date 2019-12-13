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
