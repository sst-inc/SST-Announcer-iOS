//
//  AnnouncementDrag.swift
//  Announcer
//
//  Created by JiaChen(: on 21/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension AnnouncementsViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {

        if let cell = tableView.cellForRow(at: indexPath) as? AnnouncementTableViewCell {
            
            let link = LinkFunctions.getShareURL(with: cell.post)
            
            let provider = NSItemProvider(object: link as NSItemProviderWriting)
            
            let item = UIDragItem(itemProvider: provider)
            item.localObject = link
            
            return [item]
        } else {
            return []
        }
    }
}
