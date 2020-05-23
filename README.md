# SST Announcer (iOS)
[![Language](http://img.shields.io/badge/swift-5-orange.svg?style=flat)](https://developer.apple.com/swift)
[![Xcode](http://img.shields.io/badge/xcode-11.4-red.svg?style=flat)](https://developer.apple.com/xcode)
[![Cocoapods](http://img.shields.io/badge/pod-v1.8.4-darkgray.svg?style=flat)](https://cocoapods.org/)

[![iOS](http://img.shields.io/badge/platform-iOS%2013-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![iPadOS](http://img.shields.io/badge/platform-iPadOS%2013-blue.svg?style=flat)](https://developer.apple.com/ipad/)
[![Mac Catalyst](http://img.shields.io/badge/platform-MacOS%2010.15-blue.svg?style=flat)](https://developer.apple.com/mac-catalyst/)

SST Announcer was built to help SST Students stay up to date with the school’s announcements with ease and convenience on their devices. The app allows users to browse, pin and share important announcements made by the school. The app also sends notifications to students whenever a new announcement is posted. This helped to ensure that students are kept updated with the latest information from the school. 

---
## Installation
This project uses Cocoapods. Check the Podfile for more information.

0. To install Cocoapods, in terminal, run `sudo gem install cocoapods`
1. To install the pods into the project, go to the project's directory and run `pod install` on this project
2. Open the Announcer.xcworkspace
3. Done

or just download on the [App Store](https://apps.apple.com/sg/app/sst-announcer/id683929182)

[![App Store](https://upload.wikimedia.org/wikipedia/commons/3/3c/Download_on_the_App_Store_Badge.svg)](https://apps.apple.com/sg/app/sst-announcer/id683929182)

## Requirements
- Xcode 11.4 or greater
- Swift 5 
- iOS 13 or greater
- iPadOS 13 or greater
- MacOS 10.15 or greater
- Cocoapods 1.8.4 or greater

## Technologies/Libraries Used
### Open Source Libraries
- [URLEmbeddedView](https://github.com/marty-suzuki/URLEmbeddedView)
  - Previewing Links in the blog posts
  - Installed using Cocoapods
- [FeedKit](https://github.com/nmdias/FeedKit)
  - Fetching data from Students' Blog (Atom feed)
  
### Apple Technologies
- [UIKit](https://developer.apple.com/documentation/uikit/)
  - User Interface for iOS, iPadOS and MacOS
- [Mac Catalyst](https://developer.apple.com/documentation/uikit/mac_catalyst)
  - To enable MacOS support
- [Background Tasks](https://developer.apple.com/documentation/backgroundtasks)
  - Fetching new blog posts in the background, on device.
  - This is easier and more cost effective than running a server to push notifications to each device 
    - TL;DR: I'm broke so this is the best way
    - Limitations: 
      - Unable to work with Low-Power Mode on 
- [User Notifications](https://developer.apple.com/documentation/usernotifications)
  - To send notifications to the users whenever a new post comes (works together with Background Tasks)

## Screenshots (iOS)
Dark and Light mode
### Home 
<img src="Screenshots/iPhone/iPhone 11/Dark Mode/home.png" width="200">    <img src="Screenshots/iPhone/iPhone 11/Light Mode/home.png" width="200">
### Content
<img src="Screenshots/iPhone/iPhone 11/Dark Mode/content.png" width="200">    <img src="Screenshots/iPhone/iPhone 11/Light Mode/content.png" width="200">
### Search with Tags
<img src="Screenshots/iPhone/iPhone 11/Dark Mode/search.png" width="200">    <img src="Screenshots/iPhone/iPhone 11/Light Mode/search.png" width="200">
