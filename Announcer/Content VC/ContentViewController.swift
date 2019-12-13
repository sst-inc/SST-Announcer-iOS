//
//  ContentViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
    
    var onDismiss: (() -> Void)?
    let notifManager = LocalNotificationManager()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var remindMeLaterButton: UIButton!
    
    var post: Post!
    var isPinned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Update labels/textview with data
        let attrTitle = NSMutableAttributedString(string: post.title)
        // Find the [] and just make it like red or something
        
        // Make square brackets colored
        let indicesStart = attrTitle.string.indicesOf(string: "[")
        let indicesEnd = attrTitle.string.indicesOf(string: "]")
        
        // Determine which one is smaller (start indices or end indices)
        if (indicesStart.count >= (indicesEnd.count) ? indicesStart.count : indicesEnd.count) > 0 {
            for i in 1...(indicesStart.count >= indicesEnd.count ? indicesStart.count : indicesEnd.count) {
                
                let start = indicesStart[i - 1]
                let end = indicesEnd[i - 1]
                
                // [] colors will be Carl and Shannen
                // @shannen why these color names man
                let bracketStyle : [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: UIColor.red, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .semibold)]
                
                attrTitle.addAttributes(bracketStyle, range: NSRange(location: start, length: end - start + 2))
            }
        }
        
        titleLabel.attributedText = attrTitle
        
        // Format date as "1 Jan 2019"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        dateLabel.text = "Posted on \(dateFormatter.string(from: post.date))"
        
        // Render HTML from String
        let attr = post.content.htmlToAttributedString
        
        attr?.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .medium), range: NSRange.init(location: 0, length: (attr?.length)!))
        
        contentTextField.attributedText = attr
        
        // Check if item is pinned
        // Update the button to show
        //If is in pinnned
        let pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        
        if #available(iOS 13, *) {
            if pinnedItems.contains(post) {
                isPinned = true
                pinButton.setImage(UIImage(systemName: "pin.fill")!, for: .normal)
            } else {
                isPinned = false
                pinButton.setImage(UIImage(systemName: "pin")!, for: .normal)
            }
        }
        
        // Set up Remind Me Later
        if self.notifManager.notifications.contains(where: { (notif) -> Bool in
            notif.title == "Announcer Reminder" && notif.body == self.post.title
        }) {
            self.remindMeLaterButton.setImage(UIImage(named: "clock.fill"), for: .normal)
        }
        
        contentTextField.delegate = self
    }
    
    @IBAction func sharePost(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "/yyyy/M/"
        
        //We share url not text because text is stupid
        let shareText = post.content.htmlToString
        
        //Create Activity View Controller (Share screen)
        let shareViewController = UIActivityViewController.init(activityItems: [shareText], applicationActivities: nil)
        
        //Remove unneeded actions
        shareViewController.excludedActivityTypes = [.saveToCameraRoll, .addToReadingList]
        
        //Present share sheet
        shareViewController.popoverPresentationController?.sourceView = self.view
        self.present(shareViewController, animated: true, completion: nil)
    }
    
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
    
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func remindMeLater(_ sender: Any) {
        self.performSegue(withIdentifier: "remindMeLater", sender: nil)
    }
    
    @IBAction func pinnedItem(_ sender: Any) {
        //Toggle pin based on context
        var pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        
        if isPinned {
            pinnedItems.remove(at: pinnedItems.firstIndex(of: post)!)
        } else {
            pinnedItems.append(post)
        }
        
        PinnedAnnouncements.saveToFile(posts: pinnedItems)
        
        if #available(iOS 13.0, *) {
            if pinnedItems.contains(post) {
                isPinned = true
                
                pinButton.setImage(UIImage(systemName: "pin.fill")!, for: .normal)
            } else {
                isPinned = false
                pinButton.setImage(UIImage(systemName: "pin")!, for: .normal)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        onDismiss?()
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if let dest = segue.destination as? SetDateViewController {
            dest.post = post
            dest.onDismiss = {
                if self.notifManager.listScheduledNotifications().contains(where: { (notif) -> Bool in
                    let newNotif: UNNotificationRequest = notif
                    return newNotif.content.title == "Announcer Reminder" && newNotif.content.body == self.post.title
                    
                }) {
                    self.remindMeLaterButton.setImage(UIImage(named: "clock.fill"), for: .normal)
                }
                
            }
        }
     }
     
    
}
