//
//  Emoji.swift
//  Announcer
//
//  Created by JiaChen(: on 1/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func symbolFrom(_ emoji: String) -> UIImage? {
        
        let emojis = ["✏️" : "pencil",
                      "📝" : "square.and.pencil",
                      "📁" : "folder",
                      "📂" : "folder.badge.plus",
                      "🗄" : "tray.2",
                      "📄" : "doc"]
        
        guard let symbol = emojis[emoji] else { return nil }
        
        return UIImage(systemName: symbol)
    }
}
