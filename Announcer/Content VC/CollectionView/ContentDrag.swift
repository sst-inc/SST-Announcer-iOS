//
//  ContentDrag.swift
//  Announcer
//
//  Created by JiaChen(: on 21/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension ContentViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        itemsForBeginning session: UIDragSession,
                        at indexPath: IndexPath) -> [UIDragItem] {

        if let cell = collectionView.cellForItem(at: indexPath) as? LinksCollectionViewCell {
            // Handling drag of links

            // Getting link from cell
            let link = URL(string: cell.link.link)!

            // Creating a link provider
            let provider = NSItemProvider(object: link as NSItemProviderWriting)

            // Adding the item
            let item = UIDragItem(itemProvider: provider)
            item.localObject = link

            // Returning it
            return [item]
        } else if let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {

            // Getting the filter text from cell
            var value = cell.titleLabel.text!

            // Remove tab
            if value.contains("\t") {
                // Remove \t from filter
                value.removeFirst(2)
            }

            // Creating provider
            let provider = NSItemProvider()

            // Adding the string
            let item = UIDragItem(itemProvider: provider)
            item.localObject = value

            // Returning it
            return [item]
        } else {
            // Otherwise just... crash
            fatalError("Cell not found")
        }
    }
}
