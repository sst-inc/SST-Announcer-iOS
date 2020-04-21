//
//  ContentCollectionView.swift
//  Announcer
//
//  Created by JiaChen(: on 21/4/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

extension ContentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post.categories.count
    }
    
    // CollectionView contains tags
    // Each cell is Guan Yellow and
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewCell
        
        cell.titleLabel.text = post.categories[indexPath.row]
        cell.backgroundColor = UIColor(named: "Guan Yellow")
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        
        return cell
    }

}
