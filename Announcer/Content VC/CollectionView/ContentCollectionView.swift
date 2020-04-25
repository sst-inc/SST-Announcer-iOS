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

extension ContentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == labelsCollectionView {
            return post.categories.count
        } else {
            return links.count
        }
    }
    
    // CollectionView contains labels
    // Each cell is Guan Yellow and
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == labelsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewCell
            
            cell.titleLabel.text = post.categories[indexPath.row]
            cell.backgroundColor = UIColor(named: "Guan Yellow")
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "links", for: indexPath) as! LinksCollectionViewCell
            
            cell.backgroundColor = UIColor(named: "Guan Yellow")
            
            cell.link = links[indexPath.row]
            
            cell.layer.cornerRadius = 5
            cell.clipsToBounds = true
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == labelsCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! CategoriesCollectionViewCell
            filter = cell.titleLabel.text!
            print(filter)
            filterUpdated?()
            
            navigationController?.popToRootViewController(animated: true)
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! LinksCollectionViewCell
            
            if cell.link.link.contains("http://") || cell.link.link.contains("https://") {
                let url = URL(string: cell.link.link) ?? URL(string: "https://sstinc.org/404")!
                
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true)
            } else {
                let url = URL(string: cell.link.link) ?? URL(string: "https://sstinc.org/404")!
                
                UIApplication.shared.open(url)
            }
        }
    }
}
