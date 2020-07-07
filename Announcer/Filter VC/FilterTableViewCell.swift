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
            
            DispatchQueue.global(qos: .background).async {
                
                let config = UIImage.SymbolConfiguration(weight: .medium)
                let image = self.getImage(self.title).withConfiguration(config)
                
                DispatchQueue.main.async {
                    self.imageView?.image = image
                    self.imageView?.tintColor = .systemBlue
                    self.imageView?.contentMode = .scaleAspectFit
                }
            }
            
        }
    }
    
    // Just a view with color and a corner radius
//    @IBOutlet weak var primaryView: UIView!
    
    // Contains the filter
//    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Curve the primary view
//        primaryView.layer.cornerRadius = 10
    }
    
    func getImage(_ title: String) -> UIImage {
        
        let title = title.lowercased()
        
        let imageData = getData()
        
        var imageIdentifier = "tag"
        
        for data in imageData {
            for i in data.0 {
                if title.contains(i) {
                    imageIdentifier = data.1
                    break
                }
            }
            if imageIdentifier != "tag" {
                break
            }
        }
        
        return UIImage(systemName: imageIdentifier) ?? UIImage(named: imageIdentifier) ?? UIImage(systemName: "tag")!
    }
    
    func getData() -> [([String], String)] {
        let strData = try! String(contentsOf: Bundle.main.url(forResource: "Icons", withExtension: "txt")!)
        
        let data = strData.split(separator: "\n")
        let convertedData = data.map { value -> ([String], String) in
            let item = value.split(separator: "|")
            
            let identifiers: [String] = item[0].split(separator: ",").map {
                String($0)
            }
            
            return (identifiers, String(item[1]))
        }
        
        return convertedData
    }
}
