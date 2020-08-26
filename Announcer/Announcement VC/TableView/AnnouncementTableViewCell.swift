//
//  AnnouncementTableViewCell.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit
import SkeletonView

class AnnouncementTableViewCell: UITableViewCell {

    var htmlAttr: NSMutableAttributedString!
    var parent: AnnouncementsViewController!
    var path: IndexPath!
    
    var post: Post! {
        // If the post value is changed, set these values to whatever is below in didSet
        didSet {
            // Hide all the loaders
            endLoader()
            
            // Set attributes of title label
            // [Square Brackets] all red to highlight things like [Sec 2 students] etc.
            // Set the text the label
            
            if Thread.current.isMainThread {
                // If we are on the main thread, just go ahead
                self.announcementTitleLabel.attributedText = self.setTitleLabelText()
            } else {
                // Otherwise go to the main thread
                DispatchQueue.main.async {
                    self.announcementTitleLabel.attributedText = self.setTitleLabelText()
                }
            }
            // Loading the content takes a while
            // Converting HTML to String is slow
            // Do conversion on different thread and update the cell when it's ready
            // Show loading to user
            // Loading for iOS 13 and above has fancy icon
            let str = NSMutableAttributedString(string: "")
            str.append(NSAttributedString(attachment: NSTextAttachment(image: Assets.loading)))
            str.append(NSAttributedString(string: NSLocalizedString("ERROR_LOADING",
                                                                    comment: "Loading Content")))
            
            self.announcementContentLabel.attributedText = str
            
            // Unable to preview because it requires JavaScript
            if post.content.contains("webkitallowfullscreen=\"true\"") {
                let str = NSMutableAttributedString(string: "")
                
                // Creating error message - with icon
                str.append(NSAttributedString(attachment: NSTextAttachment(image: Assets.error)))
                str.append(NSAttributedString(string: NSLocalizedString("ERROR_UNABLETOLOAD",
                                                                        comment: "Unable to Load preview")
))
                
                // Set attributed text
                self.announcementContentLabel.attributedText = str
            } else if htmlAttr == nil {
                // Handle this async so that the experience will not be super laggy
                DispatchQueue.global(qos: .default).async {
                    
                    // Convert html to string, this is the slowest part in the process
                    // Main drawback is that if there are images involved, it has to get those images from the links
                    self.htmlAttr = self.post.content.htmlToAttributedString
                    
                    if (self.parent.pinned.count != 0 && self.path.section == 1) ||
                        self.parent.pinned.count == 0 {
                        
                        self.parent.cachedContent[self.path.row] = self.htmlAttr
                    }
                    
                    print(self.path.row)
                    // Set the content
                    DispatchQueue.main.async {
                        self.setContent(with: self.htmlAttr)
                    }
                    
                }
            } else {
                self.setContent(with: htmlAttr)
            }
            
            // Ensure date is formatted as 22 Oct 2019 using d MMM yyyy
            // The date is the date posted onto studentsblog
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = NSLocalizedString("DATE_FORMAT",
                                                         comment: "Posted on 6 Aug 2020")
            
            DispatchQueue.main.async {
                self.announcementDateLabel.text = dateFormatter.string(from: self.post.date)
            }
            
            handlePinAndRead()
            
            // Set tableViewCell background color
            if I.mac {
                backgroundColor = .clear
            } else {
                backgroundColor = GlobalColors.background
            }
        }
    }
    
    var highlightPost = false {
        didSet {
            if I.wantToBeMac {
                if highlightPost {
                    contentView.backgroundColor = GlobalColors.tableViewSelection
                } else {
                    contentView.backgroundColor = GlobalColors.background
                }
            }
        }
    }
    
    @IBOutlet weak var announcementImageView: UIImageView!
    @IBOutlet weak var announcementTitleLabel: UILabel!
    @IBOutlet weak var announcementContentLabel: UILabel!
    @IBOutlet weak var announcementDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let hover = UIHoverGestureRecognizer()
        hover.addTarget(self, action: #selector(hovered(_:)))
        
        contentView.addGestureRecognizer(hover)
        
        // Set up SkeletonView
        announcementTitleLabel.isSkeletonable = true
        announcementContentLabel.isSkeletonable = true
        announcementDateLabel.isSkeletonable = true
    }
    
    // Color the brackets []
    // Make the text set
    func setTitleLabelText() -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        let defaultAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.label,
                                                                .font: font]
        
        // Update labels/textview with data
        let attrTitle = NSMutableAttributedString(string: post.title, attributes: defaultAttributes)
        // Find the [] and just make it like red or something
        
        // Make square brackets colored
        let indicesStart = attrTitle.string.indicesOf(string: "[")
        let indicesEnd = attrTitle.string.indicesOf(string: "]")
        
        // Determine which array of indices contains more values (start indices or end indices)
        let smallerIndicesArray = indicesStart.count >= (indicesEnd.count) ? indicesStart.count : indicesEnd.count
        
        // Ensure that there is more than 0 items in the array
        if smallerIndicesArray > 0 {
            for i in 1...(indicesStart.count >= indicesEnd.count ? indicesStart.count : indicesEnd.count) {
                
                let start = indicesStart[i - 1]
                let end = indicesEnd[i - 1]
                
                // Ensuring that upper bounds is more than lower bounds
                if end > start {
                    // `[]` colors will be `.blueTint`
                    // Setting the bracket style
                    let bracket: [NSAttributedString.Key: Any] = [.foregroundColor: GlobalColors.blueTint,
                                                                  .font: font]
                    
                    // Add the blue to the squared brackets in the title
                    attrTitle.addAttributes(bracket,
                                            range: NSRange(location: start, length: end - start + 2))
                }
            }
        }
        
        return attrTitle
    }
    
    // Using the SkeletonView loading animations
    // Similar to YouTube
    // Set text as " " so as to maintain proper constraints
    func startLoader() {
        announcementTitleLabel.showAnimatedSkeleton()
        announcementContentLabel.showAnimatedSkeleton()
        announcementDateLabel.showAnimatedSkeleton()
    }
    
    // Hide all loaders when content is present for user
    func endLoader() {
        announcementTitleLabel.hideSkeleton()
        announcementContentLabel.hideSkeleton()
        announcementDateLabel.hideSkeleton()
    }
    
    func handlePinAndRead() {
        // Handling pinned items
        let pinned = PinnedAnnouncements.loadFromFile()
        
        // Checking if item is pinned
        if pinned?.contains(post) ?? false {
            announcementImageView.isHidden = false
            
            // Color the pin to state if the post is pinned or not
            announcementImageView.image = Assets.unpin
            announcementImageView.tintColor = GlobalColors.greyOne
        } else {
            // Hide pin image view if post is not pinned
            announcementImageView.isHidden = true
        }
        
        // Handling read announcements
        let readAnnouncements = ReadAnnouncements.loadFromFile() ?? []
        
        // Checking if announcement is read
        if !readAnnouncements.contains(post) {
            // Handling if post is unread
            announcementImageView.isHidden = false
            
            // Adding unread indicator on unread posts
            announcementImageView.image = Assets.unread
            announcementImageView.tintColor = .systemBlue
        }
    }
    
    // Highlights the cell when hovered
    @objc func hovered(_ sender: UIHoverGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            
            // User is hovering over post
            #if targetEnvironment(macCatalyst)
            contentView.backgroundColor = GlobalColors.greyTwo
            #else
            contentView.backgroundColor = highlightPost ? GlobalColors.tableViewSelectionHover : GlobalColors.greyThree
            #endif
            
        default:
            // User stopped hovering over post
            #if targetEnvironment(macCatalyst)
            contentView.backgroundColor = .clear
            #else
            contentView.backgroundColor = highlightPost ? GlobalColors.tableViewSelection : GlobalColors.background
            #endif

        }
    }
    
    func setContent(with attributedString: NSMutableAttributedString) {
        var previewText = attributedString.htmlToString
        
        // Set contentLabel's content
        let size = self.announcementContentLabel.font.pointSize
        
        if previewText.filter({ $0.isLetter || $0.isNumber }).count == 0 {
            // Handle if post contains no text
            
            let str = NSMutableAttributedString(string: "")
            
            str.append(NSAttributedString(attachment: NSTextAttachment(image: Assets.photo)))
            
            str.append(NSAttributedString(string: NSLocalizedString("ERROR_NOTEXT",
                                                                    comment: "No text"),
                                          attributes: [.font: UIFont.italicSystemFont(ofSize: size)]))
            
            self.announcementContentLabel.attributedText = str
        } else if previewText.hasPrefix("error: ") {
            // Handle if an error occurred when getting post preview
            let str = NSMutableAttributedString(string: "")
            
            str.append(NSAttributedString(attachment: NSTextAttachment(image: (Assets.bigError))))
            
            previewText.removeFirst(7)
            
            str.append(NSAttributedString(string: "  \(previewText)",
                                          attributes: [.font: UIFont.italicSystemFont(ofSize: size)]))
            
            self.announcementContentLabel.attributedText = str
        } else {
            self.announcementContentLabel.text = previewText
        }
    }
}
