//
//  FilterTableViewCell.swift
//  Announcer
//
//  Created by JiaChen(: on 28/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    // Store the filter title
    // When set, update label
    var title = String() {
        didSet {
            // When the title variable is changed or set, update the titleLabel
            textLabel?.text = "\(title)"
            
            // Getting the filter icon image
            DispatchQueue.global(qos: .background).async {
                
                // Creating image configuration, medium
                let config = UIImage.SymbolConfiguration(weight: .medium)
                
                // Creating the image from the image received from the title
                let image = self.getImage(self.title).withConfiguration(config)
                
                // Updating the User Interface
                DispatchQueue.main.async {
                    
                    // Update the image
                    self.imageView?.image = image
                    
                    // Set the tint color to system blue from clear to show image
                    self.imageView?.tintColor = .systemBlue
                    
                    // Setting as aspect fit so it will not be distorted
                    self.imageView?.contentMode = .scaleAspectFit
                }
            }
            
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Getting image from filter
    func getImage(_ title: String) -> UIImage {
        
        // Make the title lowercased to make it easier to handle
        let title = title.lowercased()
        
        // Getting image data from Icons.txt file
        let imageData = getData()
        
        // Default value, if there is no icon found use the "tag" icon
        var imageIdentifier = "tag"
        
        // Loop through dataset and associate each one with an image
        for data in imageData {
            for i in data.0 {
                if title.contains(i) {
                    // If the label contains the search terms,
                    
                    // set the image identifier and
                    imageIdentifier = data.1
                    
                    // get out of loop
                    break
                }
            }
            
            if imageIdentifier != "tag" {
                // If the image identifier is not "tag",
                // get out of the loop because it is found
                break
            }
        }
        
        return UIImage(systemName: imageIdentifier) ?? UIImage(named: imageIdentifier) ?? UIImage(systemName: "tag")!
    }
    
    /// Getting data from the Icons.txt file
    func getData() -> [([String], String)] {
        
        // Reading from Icons.txt
        do {
            let strData = try String(contentsOf: Bundle.main.url(forResource: "Icons", withExtension: "txt")!)
            
            // Spliting the data by \n
            let data = strData.split(separator: "\n")
            
            // Mapping out the data to create an array of ([String], String)
            let convertedData = data.map { value -> ([String], String) in
                let item = value.split(separator: "|")
                
                // Identifiers are the search terms used to locate the correct icon
                let identifiers: [String] = item[0].split(separator: ",").map {
                    String($0)
                }
                
                // String item[1] is the image identifier for SF Symbols
                return (identifiers, String(item[1]))
            }
            
            // Return the converted data and we're done
            return convertedData
        } catch {
            print(error.localizedDescription)
            
            return [([""], "")]
        }
    }
}
