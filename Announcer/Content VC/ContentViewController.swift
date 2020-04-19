//
//  ContentViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit
import SafariServices

class ContentViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {
    
    var onDismiss: (() -> Void)?
    var defaultFontSize: CGFloat = 15
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    // Accessibility Increase Text Size
    @IBOutlet weak var defaultFontSizeButton: UIButton!
    @IBOutlet var increaseTextSizeGestureRecognizer: UIPinchGestureRecognizer!
    
    var post: Post!
    var isPinned = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set up custom font size system
        let currentScale = UserDefaults.standard.float(forKey: "textScale") == 0 ? 1 : CGFloat(UserDefaults.standard.float(forKey: "textScale"))
        
        increaseTextSizeGestureRecognizer.scale = currentScale
        
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
        // Handle JavaScript
        if post.content.contains("webkitallowfullscreen=\"true\"") {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Unable to Open Post", message: "An error occured when opening this post. Open this post in Safari to view its contents.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Open in Safari", style: .default, handler: { (_) in
                    self.openPostInSafari(UILabel())
                }))
                self.present(alert, animated: true)
            }
            
        } else {
            let content = post.content
            
            let attr = content.htmlToAttributedString
            
            attr?.addAttribute(.font, value: UIFont.systemFont(ofSize: defaultFontSize * increaseTextSizeGestureRecognizer.scale, weight: .medium), range: NSRange.init(location: 0, length: (attr?.length)!))
            attr?.addAttribute(.backgroundColor, value: UIColor.clear, range: NSRange(location: 0, length: (attr?.length)!))
            
            // Optimising for iOS 13 dark mode
            if #available(iOS 13.0, *) {
                attr?.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: (attr?.length)!))
            } else {
                
            }
            
            contentTextField.attributedText = attr
        }
        
        // Check if item is pinned
        // Update the button to show
        //If is in pinnned
        let pinnedItems = PinnedAnnouncements.loadFromFile() ?? []
        
        // Fill/Don't fill pin
        if #available(iOS 13, *) {
            if pinnedItems.contains(post) {
                isPinned = true
                pinButton.setImage(UIImage(systemName: "pin.fill")!, for: .normal)
            } else {
                isPinned = false
                pinButton.setImage(UIImage(systemName: "pin")!, for: .normal)
            }
        }
        
        // Set textField delegate
        contentTextField.delegate = self
        
        // Hide the tags if there are none
        if post.categories.count == 0 {
            collectionViewHeightConstraint.constant = 0
        }
        
        // Styling default font size button
        defaultFontSizeButton.layer.cornerRadius = 20
        defaultFontSizeButton.clipsToBounds = true
        defaultFontSizeButton.isHidden = true
    }
    
    @IBAction func sharePost(_ sender: Any) {
        
        //Create Activity View Controller (Share screen)
        let shareViewController = UIActivityViewController.init(activityItems: [getShareURL(with: post)], applicationActivities: [])
        
        //Remove unneeded actions
        shareViewController.excludedActivityTypes = [.addToReadingList]
        
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
        
        onDismiss?()
    }
    
    @IBAction func openPostInSafari(_ sender: Any) {
        let vc = SFSafariViewController(url: getShareURL(with: post))
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pinchedTextField(_ sender: UIPinchGestureRecognizer) {
        print(sender.scale)
        
        let attr = NSMutableAttributedString(attributedString: contentTextField.attributedText)
        
        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 15 * sender.scale, weight: .medium), range: NSRange.init(location: 0, length: attr.length))
        
        contentTextField.attributedText = attr
        
        UserDefaults.standard.set(sender.scale, forKey: "textScale")
        
        if sender.state == .ended || sender.state == .cancelled && sender.scale != 1 {
            
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
                self.defaultFontSizeButton.isHidden = true
            }
        } else {
            if sender.scale != 1 {
                defaultFontSizeButton.isHidden = false
            } else {
                defaultFontSizeButton.isHidden = true
            }
            
        }
    }
    
    @IBAction func resetToDefaultFontSize(_ sender: Any) {
        let attr = NSMutableAttributedString(attributedString: contentTextField.attributedText)
        
        attr.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .medium), range: NSRange(location: 0, length: attr.length))
        
        contentTextField.attributedText = attr
        
        defaultFontSizeButton.isHidden = true
    }
    
    // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
        if let dest = segue.destination as? SetDateViewController {
            dest.post = post
            dest.onDismiss = {
            }
        }
     }
}
