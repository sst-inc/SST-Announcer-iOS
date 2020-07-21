//
//  ContentTouchBar.swift
//  Announcer
//
//  Created by JiaChen(: on 21/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

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
        
        let flexibleSpacing = NSTouchBarItem(identifier: .flexibleSpace)

        let next = NSButtonTouchBarItem(identifier: NSTouchBarItem.Identifier("next"), image: UIImage(systemName: "chevron.right")!, target: self, action: #selector(nextPost))
        
        let prev = NSButtonTouchBarItem(identifier: NSTouchBarItem.Identifier("prev"), image: UIImage(systemName: "chevron.left")!, target: self, action: #selector(previousPost))
        
        return NSGroupTouchBarItem(identifier: identifier, items: [pin, share, safari, flexibleSpacing, prev, next])
    }
}
