//
//  String Extension.swift
//  Announcer
//
//  Created by JiaChen(: on 21/4/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation

// For displaying data previews and displaying full screen
extension String {
    var htmlToAttributedString: NSMutableAttributedString? {
        do {
            return try NSMutableAttributedString(data: Data(utf8),
                                                 options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: 4],
                                                 documentAttributes: nil)
        } catch {
            print("error: ", error.localizedDescription)
            return NSMutableAttributedString(string: "error: " + error.localizedDescription)
        }
    }
    
    var htmlToString: String {
        // MacOS Catalyst does not work properly
        #if targetEnvironment(macCatalyst)
            return "Unable to display preview on Mac"
        #else
            return (htmlToAttributedString ?? NSAttributedString(string: "")).string.condenseLinebreaks()
        #endif
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    
    func removeWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeLabel() -> String {
        var str = self
        str.removeFirst(getLabelsFromSearch(with: self).count)
        return str
    }
    
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: CharacterSet.whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
    
    func condenseLinebreaks() -> String {
        let split = self.split(separator: "\n")
        var isLinebreak = false
        var returnString = ""
        
        for i in split {
            if i == "\n" {
                if !isLinebreak {
                    isLinebreak = true
                    returnString += "\n"
                }
            } else {
                isLinebreak = false
                returnString.append(i + "\n")
            }
        }
        return returnString
    }
    
    func truncateBy(_ characters: Int) -> String {
        if self.count > characters {
            let item = index(startIndex, offsetBy: characters)
            let mySubstring = self[..<item] + "…"
            
            return String(mySubstring)
        } else {
            return self
        }
        
    }
}
