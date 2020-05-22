# Announcer 2020
## Overview
SST Announcer was built to help SST Students stay up to date with the school’s announcements with ease and convenience on their devices. The app allows users to browse, pin and share important announcements made by the school. The app also sends notifications to students whenever a new announcement is posted. This helped to ensure that students are kept updated with the latest information from my school. 

---
## Installation
- run `pod install` (there is one or two pods there)
- open the Announcer.xcworkspace
- done

or download on the [app store](https://apps.apple.com/sg/app/sst-announcer/id683929182)

## Support
|Operating System|Latest Version|Note|
|:--------------:|:------------:|:--:|
|iOS|11.0.1||
|iPadOS|11.0.1||
|MacOS|11.0.1|Certain features may not work as intended|

## Technologies/Libraries Used
### Open Source Libraries
- [URLEmbeddedView](https://github.com/marty-suzuki/URLEmbeddedView)
  - Previewing Links in the blog posts
- [FeedKit](https://github.com/nmdias/FeedKit)
  - Fetching data from Students' Blog (Atom feed)
  
### Apple Technologies
- [Background Tasks](https://developer.apple.com/documentation/backgroundtasks)
  - Fetching new blog posts in the background, on device.
  - This is easier and more cost effective than running a server to push notifications to each device 
    - TL;DR: I'm broke so this is the best way
- [User Notifications](https://developer.apple.com/documentation/usernotifications)
  - To send notifications to the users whenever a new post comes (works together with Background Tasks)
- [Mac Catalyst](https://developer.apple.com/documentation/uikit/mac_catalyst)
  - To enable MacOS support
