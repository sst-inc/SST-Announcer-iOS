//
//  Labels.swift
//  Announcer
//
//  Created by JiaChen(: on 27/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import Foundation
import SystemConfiguration
import UserNotifications
import UIKit

// Blog URL
// should be https://studentsblog.sst.edu.sg unless testing
#warning("Make sure the blog URL is correct on launch")
let blogURL = "http://studentsblog.sst.edu.sg"

// RSS URL
let rssURL = URL(string: "\(blogURL)/feeds/posts/default")!

// JSON Callback URL
// Returns back the Labels for sorting
// http://studentsblog.sst.edu.sg/feeds/posts/summary?alt=json&max-results=0&callback=cat
let jsonCallback = URL(string: "\(blogURL)/feeds/posts/summary?alt=json&max-results")!

var filter = ""

// Struct that contains the date, content and title of each post
struct Post: Codable, Equatable {
    var title: String
    var content: String // This content will be a HTML as a String
    var date: Date
    
    var pinned: Bool
    var read: Bool
    var reminderDate: Date?
    
    var categories: [String]
}

// JSON Callback to get all the labels for the blog posts
func fetchLabels() -> [String] {
    var labels = [String]()
    
    do {
        let strData = try String(contentsOf: jsonCallback)
        let split = strData.split(separator: ",")
        let filtered = split.filter { (value) -> Bool in
            
            return value.contains("term")
        }
        
        for item in filtered {
            labels.append(String(item).replacingOccurrences(of: "{\"term\":\"", with: "").replacingOccurrences(of: "\"}", with: "").replacingOccurrences(of: "\\u0026", with: "\u{0026}"))
        }
        labels[0].removeFirst("\"category\":[".count)
        labels[labels.count - 1].removeLast()
    } catch {
        print(error.localizedDescription)
    }
    
    return labels
}

func fetchBlogPosts(_ vc: AnnouncementsViewController) -> [Post] {
    let parser = FeedParser(URL: rssURL)
    let result = parser.parse()
    
    switch result {
    case .success(let feed):
        print(feed)
        let feed = feed.atomFeed
        
        return convertFromEntries(feed: (feed?.entries!)!)
    case .failure(let error):
        print(error.localizedDescription)
        // Present alert
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Uh Oh :(", message: "Slow or no internet connection.\nPlease check your settings and try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: .default, handler: { action in
                vc.reload(UILabel())
            }))
            
            alert.addAction(UIAlertAction(title: "Open in Settings", style: .default, handler: { action in
                let url = URL(string: "App-Prefs:root=")!
                UIApplication.shared.open(url, options: [:]) { (success) in
                    print(success)
                }
            }))
            
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
                
            }))
            
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    return []
}

func fetchNotificationsTitle(_ vc: AnnouncementsViewController) -> String {
    let parser = FeedParser(URL: rssURL)
    let result = parser.parse()
    
    switch result {
    case .success(let feed):
        print(feed)
        let feed = feed.atomFeed
        return convertFromEntries(feed: (feed?.entries!)!).first!.title
    case .failure(let error):
        return "Check your wifi\n\(error.localizedDescription)"
    }
}


// Convert Enteries to Posts
func convertFromEntries(feed: [AtomFeedEntry]) -> [Post] {
    var posts = [Post]()
    for entry in feed {
        let cat = entry.categories ?? []
        
        posts.append(Post(title: entry.title!,
                          content: (entry.content?.value)!,
                          date: entry.published!,
                          pinned: false,
                          read: false,
                          reminderDate: nil,
                          categories: {
                            var categories: [String] = []
                            for i in cat {
                                categories.append((i.attributes?.term!)!)
                            }
                            return categories
        }()))
        
    }
    return posts
}

func getTagsFromSearch(with query: String) -> String {
    // Tags in search are a mess to deal with
    if query.first == "[" {
        let split = query.split(separator: "]")
        var result = split[0]
        result.removeFirst()
        
        return String(result.lowercased())
    }
    return ""
}

// For displaying data previews and displaying full screen
extension String {
    var htmlToAttributedString: NSMutableAttributedString? {
        do {
            return try NSMutableAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error.localizedDescription)
            return nil
        }
    }
    
    var htmlToString: String {
        // MacOS Catalyst does not work properly
        #if targetEnvironment(macCatalyst)
        return ""
        #else
            return htmlToAttributedString?.string ?? ""
        #endif
    }
    
    func indicesOf(string: String) -> [Int] {
        var indices = [Int]()
        var searchStartIndex = self.startIndex
        
        while searchStartIndex < self.endIndex,
            let range = self.range(of: string, range: searchStartIndex..<self.endIndex),
            !range.isEmpty
        {
            let index = distance(from: self.startIndex, to: range.lowerBound)
            indices.append(index)
            searchStartIndex = range.upperBound
        }
        
        return indices
    }
    
    func removeWhitespace() -> String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeTags() -> String {
        var str = self
        str.removeFirst(getTagsFromSearch(with: self).count)
        return str
    }

}

extension UIColor {
    
    static func +(color1: UIColor, color2: UIColor) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))

        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)

        // add the components, but don't let them go above 1.0
        return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
    }

    static func *(color: UIColor, multiplier: CGFloat) -> UIColor {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return UIColor(red: r * CGFloat(multiplier), green: g * CGFloat(multiplier), blue: b * CGFloat(multiplier), alpha: a)
    }
}

extension UISearchBar {
    
    func getTextField() -> UITextField? { return value(forKey: "searchField") as? UITextField }
    func set(textColor: UIColor) { if let textField = getTextField() { textField.textColor = textColor } }
    func setPlaceholder(textColor: UIColor) { getTextField()?.setPlaceholder(textColor: textColor) }
    func setClearButton(color: UIColor) { getTextField()?.setClearButton(color: color) }
    
    func setTextField(color: UIColor) {
        guard let textField = getTextField() else { return }
        switch searchBarStyle {
        case .minimal:
            textField.layer.backgroundColor = color.cgColor
            textField.layer.cornerRadius = 6
        case .prominent, .default: textField.backgroundColor = color
        @unknown default: break
        }
    }
    
    func setSearchImage(color: UIColor) {
        guard let imageView = getTextField()?.leftView as? UIImageView else { return }
        imageView.tintColor = color
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
    }
}

private extension UITextField {
    
    private class Label: UILabel {
        private var _textColor = UIColor.lightGray
        override var textColor: UIColor! {
            set { super.textColor = _textColor }
            get { return _textColor }
        }
        
        init(label: UILabel, textColor: UIColor = .lightGray) {
            _textColor = textColor
            super.init(frame: label.frame)
            self.text = label.text
            self.font = label.font
        }
        
        required init?(coder: NSCoder) { super.init(coder: coder) }
    }
    
    
    private class ClearButtonImage {
        static private var _image: UIImage?
        static private var semaphore = DispatchSemaphore(value: 1)
        static func getImage(closure: @escaping (UIImage?)->()) {
            DispatchQueue.global(qos: .userInteractive).async {
                semaphore.wait()
                DispatchQueue.main.async {
                    if let image = _image { closure(image); semaphore.signal(); return }
                    guard let window = UIApplication.shared.windows.first else { semaphore.signal(); return }
                    let searchBar = UISearchBar(frame: CGRect(x: 0, y: -200, width: UIScreen.main.bounds.width, height: 44))
                    window.rootViewController?.view.addSubview(searchBar)
                    searchBar.text = "txt"
                    searchBar.layoutIfNeeded()
                    _image = searchBar.getTextField()?.getClearButton()?.image(for: .normal)
                    closure(_image)
                    searchBar.removeFromSuperview()
                    semaphore.signal()
                }
            }
        }
    }
    
    func setClearButton(color: UIColor) {
        ClearButtonImage.getImage { [weak self] image in
            guard   let image = image,
                let button = self?.getClearButton() else { return }
            button.imageView?.tintColor = color
            button.setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    var placeholderLabel: UILabel? { return value(forKey: "placeholderLabel") as? UILabel }
    
    func setPlaceholder(textColor: UIColor) {
        guard let placeholderLabel = placeholderLabel else { return }
        let label = Label(label: placeholderLabel, textColor: textColor)
        setValue(label, forKey: "placeholderLabel")
    }
    
    func getClearButton() -> UIButton? { return value(forKey: "clearButton") as? UIButton }
}
