# SST Announcer (iOS)
[![Language](http://img.shields.io/badge/swift-5-orange.svg?style=flat)](https://developer.apple.com/swift)
[![Xcode](http://img.shields.io/badge/xcode-11.4-red.svg?style=flat)](https://developer.apple.com/xcode)
[![Cocoapods](http://img.shields.io/badge/pod-v1.8.4-darkgray.svg?style=flat)](https://cocoapods.org/)

[![iOS](http://img.shields.io/badge/platform-iOS%2013-blue.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![iPadOS](http://img.shields.io/badge/platform-iPadOS%2013-blue.svg?style=flat)](https://developer.apple.com/ipad/)
[![Mac Catalyst](http://img.shields.io/badge/platform-MacOS%2010.15-blue.svg?style=flat)](https://developer.apple.com/mac-catalyst/)

SST Announcer was built to help SST Students stay up to date with the school’s announcements with ease and convenience on their devices. The app allows users to browse, pin and share important announcements made by the school. The app also sends notifications to students whenever a new announcement is posted. This helped to ensure that students are kept updated with the latest information from the school. 

> Original design by *FourierIndustries (formerly StatiX Industries)*
>
> Revamped in 2018 by *OrbitIndustries*
>
> Revamped, again, in 2020 by *Jia Chen and Shannen*

---
## Installation
This project uses Cocoapods. Check the Podfile for more information.

0. To install Cocoapods, in terminal, run `sudo gem install cocoapods`
1. To install the pods into the project, go to the project's directory and run `pod install` on this project
2. Open the `Announcer.xcworkspace`
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
- [KALoader](https://github.com/Kirillzzy/KALoader)
  - Loading animations while getting data from RSS feed
  
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
- [Core Spotlight](https://developer.apple.com/documentation/corespotlight)
  - To allow users to search for announcements using spotlight search

## Screenshots (iOS)
Dark and Light mode
### Home 
<img src="Screenshots/iPhone/iPhone 6.5in/Dark Mode/home.png" width="250"><img src="Screenshots/iPhone/iPhone 6.5in/Light Mode/home.png" width="250">
### Content
<img src="Screenshots/iPhone/iPhone 6.5in/Dark Mode/content.png" width="250"><img src="Screenshots/iPhone/iPhone 6.5in/Light Mode/content.png" width="250">
### Search with Tags
<img src="Screenshots/iPhone/iPhone 6.5in/Dark Mode/search.png" width="250"><img src="Screenshots/iPhone/iPhone 6.5in/Light Mode/search.png" width="250">
### Spotlight Search
<img src="Screenshots/iPhone/iPhone 6.5in/spotlight.png" width="250">

## Colors
### Main Colors
These colors are used for different parts of the app such as backgrounds and labels.

|Color Name |Identifier|Light Theme|Dark Theme |
|-----------|----------|-----------|-----------|
|Background |`"background"`|![](https://via.placeholder.com/15/F5F4F6/F5F4F6) - #F5F4F6|![](https://via.placeholder.com/15/060400/060400) - #060400|
|Global Tint|`"Global Tint"`|![](https://via.placeholder.com/15/A9A9A9/A9A9A9) - #A9A9A9|![](https://via.placeholder.com/15/A9A9A9/A9A9A9) - #A9A9A9|
|Grey 1     |`"Grey 1"`|![](https://via.placeholder.com/15/434343/434343) - #434343|![](https://via.placeholder.com/15/B8BABB/B8BABB) - #B8BABB|
|Grey 2     |`"Grey 2"`|![](https://via.placeholder.com/15/DCDADB/DCDADB) - #DCDADB|![](https://via.placeholder.com/15/252628/252628) - #252628|

### Apple Colors
These colors are the ones as part of Apple's [UIColor Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/color/)

|Color Name |API     |Light Theme|Dark Theme |
|-----------|--------|-----------|-----------|
|Blue       |`.systemBlue`|![](https://via.placeholder.com/15/007BFF/007BFF) - #007BFF|![](https://via.placeholder.com/15/0A84FF/0A84FF) - #0A84FF|
|Label      |`.label`|![](https://via.placeholder.com/15/000000/000000) - #000000|![](https://via.placeholder.com/15/FFFFFF/FFFFFF) - #FFFFFF|

### Loading Colors
These colors are used for loading content using KALoader

|Color Name |Identifier|Light Theme|Dark Theme |
|-----------|----------|-----------|-----------|
|First Load Color|`"First Load Color"`|![](https://via.placeholder.com/15/DEDEDE/DEDEDE) - #DEDEDE|![](https://via.placeholder.com/15/202020/202020) - #202020|
|Second Load Color|`"Second Load Color"`|![](https://via.placeholder.com/15/DDDDDD/DDDDDD) - #DDDDDD|![](https://via.placeholder.com/15/212121/212121) - #212121|
|Back Gray Color |`"Back Gray Color"`|![](https://via.placeholder.com/15/F6F6F6/F6F6F6) - #F6F6F6|![](https://via.placeholder.com/15/080808/080808) - #080808|
