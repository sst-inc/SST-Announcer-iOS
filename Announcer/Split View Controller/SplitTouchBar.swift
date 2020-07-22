//
//  ContentTouchBar.swift
//  Announcer
//
//  Created by JiaChen(: on 21/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

#if targetEnvironment(macCatalyst)
extension SplitViewController: NSTouchBarDelegate {
    override func makeTouchBar() -> NSTouchBar? {
        let touchBar = NSTouchBar()

        touchBar.defaultItemIdentifiers = [NSTouchBarItem.Identifier("content")]

        touchBar.delegate = self

        return touchBar
    }

    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItem.Identifier) -> NSTouchBarItem? {
        
        let pin = NSButtonTouchBarItem(identifier: NSTouchBarItem.Identifier("pin"), image: Assets.pin, target: self, action: #selector(pinPost))
        
        let share = NSButtonTouchBarItem(identifier: NSTouchBarItem.Identifier("share"), image: Assets.share, target: self, action: #selector(sharePost))

        let safari = NSButtonTouchBarItem(identifier: NSTouchBarItem.Identifier("safari"), image: Assets.safari, target: self, action: #selector(openSafari))
        
        let spacing = NSTouchBarItem(identifier: .fixedSpaceLarge)

        let next = NSButtonTouchBarItem(identifier: NSTouchBarItem.Identifier("next"), image: UIImage(systemName: "chevron.right")!, target: self, action: #selector(nextPost))
        
        let prev = NSButtonTouchBarItem(identifier: NSTouchBarItem.Identifier("prev"), image: UIImage(systemName: "chevron.left")!, target: self, action: #selector(previousPost))
        
        let search = NSButtonTouchBarItem(identifier: NSTouchBarItem.Identifier("search"), image: UIImage(systemName: "magnifyingglass")!, target: self, action: #selector(startSearching))
        
        
        return NSGroupTouchBarItem(identifier: identifier, items: [search, spacing, prev, next, spacing, pin, share, safari])
    }
}
#endif
