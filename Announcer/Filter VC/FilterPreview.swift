//
//  FilterPreview.swift
//  Announcer
//
//  Created by JiaChen(: on 6/6/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension FilterTableViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let filterText = (interaction.view as! FilterTableViewCell).title
        
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in // menu elements from responder chain if any
            
            let openFilter = UIAction(title: "Filter Posts",
                                    image: Assets.filter,
                                    identifier: nil,
                                    discoverabilityTitle: nil,
                                    attributes: [],
                                    state: .off) { (_) in
                                        // Pass the cell's title over to the next VC
                                        filter = filterText
                                        
                                        self.dismiss(animated: true) {
                                            // Run an onDismiss void which is defined in the AnnouncementVC file
                                            // This void tells the AnnouncementVC to filter based on the selected label
                                            self.onDismiss!()
                                        }
            }
            
            let copyFilter = UIAction(title: "Copy Filter",
                                      image: Assets.copy,
                                      identifier: nil,
                                      discoverabilityTitle: nil,
                                      attributes: [],
                                      state: .off) { (_) in
                                        
                                        // Copy filter
                                        UIPasteboard.general.string = filterText
            }
            
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: [],
                          children: [openFilter, copyFilter])
        }
        
        return UIContextMenuConfiguration(identifier: GlobalIdentifier.filterSelection,
                                          previewProvider: nil,
                                          actionProvider: actionProvider)
    }
}
