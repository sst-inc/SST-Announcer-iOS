//
//  Search.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation

/**
 Gets the labels from search queries
 
 - returns: Label within the search query
 
 - parameters:
    - query: A String containing the search query
  
 This method locates the squared brackets `[]` in search queries and returns the Label within the query.
*/
func getLabelsFromSearch(with query: String) -> String {
    // Labels in search are a mess to deal with
    if query.first == "[" {
        let split = query.split(separator: "]")
        var result = split[0]
        result.removeFirst()
        
        return String(result.lowercased())
    }
    return ""
}
