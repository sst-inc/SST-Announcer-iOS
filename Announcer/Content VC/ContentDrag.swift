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
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if let cell = collectionView.cellForItem(at: indexPath) as? LinksCollectionViewCell {
            
            let link = URL(string: cell.link.link)!
            
            let provider = NSItemProvider(object: link as NSItemProviderWriting)
            let item = UIDragItem(itemProvider: provider)
            item.localObject = link
            
            return [item]
        } else if let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell {
            
            let value = cell.titleLabel.text!
            
            let provider = NSItemProvider()
            
            let item = UIDragItem(itemProvider: provider)
            item.localObject = value
            
            return [item]
        } else {
            fatalError()
        }
    }
}
