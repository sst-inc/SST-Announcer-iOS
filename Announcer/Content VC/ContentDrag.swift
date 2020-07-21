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
        let cell = collectionView.cellForItem(at: indexPath) as? LinksCollectionViewCell
        
        let provider = NSItemProvider(object: URL(string: (cell?.link.link)!)! as NSItemProviderWriting)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = URL(string: (cell?.link.link)!)!
        
        return [item]
    }
}
