//
//  Assets.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

/// Struct stores all the images used
struct Assets {
    // Post status icons
    static let pin                      = UIImage(systemName: "pin")!
    static let unpin                    = UIImage(systemName: "pin.fill")!
    static let loading                  = UIImage(systemName: "arrow.clockwise")!
    static let error                    = UIImage(systemName: "exclamationmark.triangle.fill")!
    static let bigError                 = UIImage(systemName: "xmark.octagon.fill")!
    static let unread                   = UIImage(systemName: "circle.fill")!
    
    // Link Icons
    static let mail                     = UIImage(systemName: "envelope.circle.fill")!
    static let docs                     = UIImage(systemName: "envelope.circle.fill")!
    static let folder                   = UIImage(systemName: "folder.circle.fill")!
    static let call                     = UIImage(systemName: "phone.circle.fill")!
    static let socialMedia              = UIImage(systemName: "person.crop.circle.fill")!
    static let video                    = UIImage(systemName: "film.fill")!
    static let photo                    = UIImage(systemName: "photo.fill")!
    static let defaultLinkIcon          = UIImage(systemName: "link.circle.fill")!
    
    // Preview icons
    static let share                    = UIImage(systemName: "square.and.arrow.up")!
    static let open                     = UIImage(systemName: "envelope.open")!
    static let readingList              = UIImage(systemName: "eyeglasses")!
    static let copy                     = UIImage(systemName: "doc.on.doc")!
    
    // Header icons
    static let filter                   = UIImage(systemName: "line.horizontal.3.decrease.circle")!
    static let filterFill               = UIImage(systemName: "line.horizontal.3.decrease.circle.fill")!
    static let safari                   = UIImage(systemName: "safari")!
    static let settings                 = UIImage(systemName: "gear")!
    
    // Zooming Icon
    static let zoomIn                   = UIImage(systemName: "plus.magnifyingglass")!
    static let zoomOut                  = UIImage(systemName: "minus.magnifyingglass")!
    static let resetZoom                = UIImage(systemName: "1.magnifyingglass")!
    
    static let checkmark                = UIImage(systemName: "checkmark")!
    static let cross                    = UIImage(systemName: "xmark")!
    static let home                     = UIImage(systemName: "house")!
    
    // swiftlint:disable colon
    static let subjectIcons = ["el"       : ["a.book.closed", "English"],                      // 􀫕
                               "math"     : ["x.squareroot", "Math"],                          // 􀓪
                               "s&w"      : ["sportscourt", "S&W"],                            // 􀝐
                               "hum"      : ["person", "Humanities"],                          // 􀉩
                               "sci"      : ["thermometer", "Science"],                        // 􀇬
                               
                               // Mother tongue
                               "cl"       : ["globe", "Mother Tongue"],                        // 􀆪
                               "ml"       : ["globe", "Mother Tongue"],                        // 􀆪
                               "tl"       : ["globe", "Mother Tongue"],                        // 􀆪
                               
                               // Changemakers
                               "cm(ict)"  : ["swift", "ICT"],                                  // 􀫊
                               "cm(ps)"   : ["mic", "Presentation Skills"],                    // 􀊰
                               "cm(admt)" : ["scribble", "ADMT"],                              // 􀓨
                               "i&e"      : ["paperplane", "I&E"],                             // 􀈟
                               "cm lesson": ["lightbulb", "Changemakers"],                     // 􀛭
                               
                               // Applied Subjects
                               "comp"     : ["cpu", "Computing"],                              // 􀫥
                               "elec"     : ["bolt.fill.batteryblock", "Electronics"],         // 􀫮
                               "design"   : ["paintpalette", "Design Studies"],                // 􀝥
                               "biotech"  : ["leaf", "Biotech"],                               // 􀥲
                               
                               // Humanities
                               "ch(ge)"   : ["mappin.and.ellipse", "Geography"],               // 􀎫
                               "ch(he)"   : ["clock", "History"],                              // 􀐫
                               "ss"       : ["building.columns", "Social Studies"],            // 􀤨
                               
                               // Science
                               "bio"      : ["hare", "Biology"],                               // 􀓎
                               "phy"      : ["scalemass", "Physics"],                          // 􀭭
                               "chem"     : ["atom", "Chemistry"],                             // 􀬚
                               
                               // Others
                               "break"    : ["zzz", "Break"],                                  // 􀖃
                               "adv/assb" : ["face.smiling", "adv/assb"],                      // 􀎸
                               "cce"      : ["face.smiling", "CCE"],                           // 􀎸
                               "other"    : ["studentdesk", "(null)"],                         // 􀑔
                               
                               // Special state icons
                               "|weekend|": ["calendar", "It's \(Date().day())!"],             // 􀉉
                               "|before|" : ["clock", "Starting Soon"],                        // 􀐫
                               "|over|"   : ["house", "Class Dismissed!"]                      // 􀎞
    ]
    // swiftlint:enable colon
    
    // Subject icons
    // Key: Subject Name, Item: image
    // Some of the icons being used are only available on SF Symbols iOS 14/MacOS 11
    @available(iOS 14, macOS 11, *)
    static func getSubject(_ identifier: String, font: UIFont) -> (UIImage, String) {
        let subject = subjectIcons[identifier] ?? subjectIcons["other"]!
        let icon = UIImage(systemName: subject[0], withConfiguration: UIImage.SymbolConfiguration(font: font))!
        
        return (icon, subject[1])
    }
}
