//
//  ContentViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextView!
    
    var post: Post!
    
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
        
        var attr = post.content.htmlToAttributedString
        
        if post.content.contains("<iframe") {
            //Format and remove all iframes while converting them into attachment links
            var entireText = post.content
            attr?.append(NSAttributedString(string: "\n\n"))
            while entireText.contains("<iframe") {
                
                //Find source of embedded content
                let upperBound = post.content.range(of: "<iframe")
                let lowerBound = post.content.range(of: "></iframe>")?.lowerBound
                let nextBound = post.content.range(of: "src=")?.upperBound
                let iframeText = post.content[(upperBound?.upperBound)!..<lowerBound!]
                let sourceLink = iframeText[nextBound!...].replacingOccurrences(of: "\"", with: "")
                
                //Append embedded content link as attachment links
                attr?.append(NSAttributedString(string: "[Attachment]: " + sourceLink))
                
                //Remove current iframe and move onto next if possible
                entireText.removeSubrange(upperBound!)
            }
        }
        
        attr?.addAttribute(.font, value: UIFont.systemFont(ofSize: 15, weight: .medium), range: NSRange.init(location: 0, length: (attr?.length)!))
        
        contentTextField.attributedText = attr
    }
    
    @IBAction func sharePost(_ sender: Any) {
        //Get text of post
        let shareText = post.content.htmlToString
        
        //Create Activity View Controller (Share screen)
        let shareViewController = UIActivityViewController.init(activityItems: [shareText], applicationActivities: nil)
        
        //Remove unneeded actions
        shareViewController.excludedActivityTypes = [.saveToCameraRoll, .addToReadingList]
        
        //Present share sheet
        shareViewController.popoverPresentationController?.sourceView = self.view
        self.present(shareViewController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
