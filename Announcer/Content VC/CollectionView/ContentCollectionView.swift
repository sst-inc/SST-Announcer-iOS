//
//  ContentCollectionView.swift
//  Announcer
//
//  Created by JiaChen(: on 21/4/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

extension ContentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // Setting the number of items in the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == labelsCollectionView {
            let numberOfItems = post.categories.count
            return numberOfItems
        } else {
            return links.count
        }
    }
    
    // Setting the content of collectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == labelsCollectionView {
            // Handling the Labels
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewCell
            
            cell.backgroundColor = GlobalColors.greyTwo
            
            cell.titleLabel.text = post.categories[indexPath.row]
            
            // Setting Cell Corner Radius
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            
            return cell
        } else {
            // Handling the Links
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "links", for: indexPath) as! LinksCollectionViewCell
            
            cell.backgroundColor = GlobalColors.greyTwo
            
            cell.link = links[indexPath.row]
            
            // Setting Cell Corner Radius
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == labelsCollectionView {
            // Handling the Labels
            let cell = collectionView.cellForItem(at: indexPath) as! CategoriesCollectionViewCell
            
            filter = cell.titleLabel.text!
            
            filterUpdated?()
            
            navigationController?.popToRootViewController(animated: true)
        } else {
            // Handling the Links
            let cell = collectionView.cellForItem(at: indexPath) as! LinksCollectionViewCell
            
            // Handle if it is a "mailto:" or something else. Or just a normal URL.
            // When it is a normal URL, present a Safari View Controller
            // Otherwise just open the URL and iOS will handle it
            if cell.link.link.contains("http://") || cell.link.link.contains("https://") {
                let url = URL(string: cell.link.link) ?? GlobalLinks.errorNotFoundURL
                
                let svc = SFSafariViewController(url: url)
                
                present(svc, animated: true)
            } else {
                let url = URL(string: cell.link.link) ?? GlobalLinks.errorNotFoundURL
                
                UIApplication.shared.open(url)
            }
        }
    }
}
