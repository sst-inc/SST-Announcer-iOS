#  Releases
## Overview
### SST Announcer Release Information
| Release Information    | Version Number |
|------------------------|:--------------:|
| Released on App Store  | 11.1           |
| Pre-Release            | 11.2           |

---

### Version History
| Version | Minimum Support             | Full Support                | Release Status                                                                 |
|---------|-----------------------------|-----------------------------|--------------------------------------------------------------------------------|
|11.2     |iOS/iPadOS 13.0, MacOS 11.0  |iOS/iPadOS 14.0, MacOS 11.0  |![Pre-Release](https://img.shields.io/badge/Pre--Release-yellow.svg?style=flat) |
|11.1     |iOS/iPadOS 13.0              |iOS/iPadOS 13.0              |![Released](https://img.shields.io/badge/Released-blue.svg?style=flat)          |
|11.0.1   |iOS/iPadOS 13.0              |iOS/iPadOS 13.0              |![EOL](https://img.shields.io/badge/End--Of--Life-critical.svg?style=flat)      |
|11.0     |iOS/iPadOS 13.0              |iOS/iPadOS 13.0              |![EOL](https://img.shields.io/badge/End--Of--Life-critical.svg?style=flat)      |

## Release Notes
<details>
<summary><strong>11.2 </strong></summary>

![Pre-Release](https://img.shields.io/badge/Pre--Release-yellow.svg?style=flat)

---
<details>
<summary><strong>Beta 1</strong></summary>

- Xcode and iOS Beta 3 does not support WidgetKit yet.

### Known Issues
#### Investigating
- When setting timetable, it always defaults to S4-07 [MacOS, iOS, iPadOS]
- App crashes when copying an image from contextual menu [iOS, iPadOS]
- Scroll selection does not include Announcer Timetables, inconsistent scroll selection style [iOS, iPadOS]

#### Resolved Issues
- Back button shows and disappears non-stop when resizing window [MacOS]
- Back button is now properly hidden [iOS]
- Announcement Interface background color [iOS]
- Loading bug where it shows "Label" instead of actual content [MacOS, iOS, iPadOS]
- Random titles highlighted wrongly

</details>

---

### Bug Fixes
- Fixed encoding errors which caused inverted commas and other symbols to be encoded as a bunch of strange symbols
- Fixed bug which caused app to crash when saving images from posts

---

### New Features
#### Announcer Timetables*
- Check your timetables from a iOS 14 widget
- Set it up by pressing the table button in the corner and type your class
- This feature uses on-device intelligence to generate a timetable.
- Generating Timetables takes about 5 minutes.
	- Please do not turn off the device while the app is generating.
	- The app will display logs based on what it is doing.

#### Contextual menu previewing support
- Added contextual menu to areas such as Filters and more
- 3D Touch, Right Click or Long Press on filters, links and more to copy or open it

#### Links and Labels section
- It will automatically hide when scrolling down. This provides more space for content.
- It will show up again when you scroll up to top

#### Error Handling 
- If there is an error when opening the post, it will now ask if you want to close the post
- Posts that require Javascript, or on MacOS, posts with images, may throw errors

#### Drag and Drop
- Drag posts, links and fliters around to share them
- Works best on iPadOS and MacOS

#### Hard to Read?
- Added a Hard to Read? button when viewing posts with dark mode

#### Feedback Reporting
- Any suggestions on how we can improve SST Announcer? Any crashes or unexpected behaviours you experienced? 
- Use the Feedback Reporting tool in SST Announcer to report an issue. 
- When reporting issues, please provide instructions on how to recreate it so we can look into the issue.

---

### iPadOS & MacOS support*
#### Redesigned 
- Takes full advantage of the screen size with a new split-screen design

#### [iPadOS/MacOS] Pointer/Cursor Support
- New animations when hovering over buttons and more
- Secondary/Right Click support

#### [iPadOS/MacOS] Keyboard Shortcuts
- Navigate posts with up and down arrow keys
- Use ⌘F to search for posts
- Find all the keyboard shortcuts in Announcer settings or by holding down ⌘ on iPad

#### [MacOS] Touch Bar support*
- Announcer now supports Touch Bar
- Use it to pin, share and navigate around posts

*Requires iOS 14, iPadOS 14 or MacOS Big Sur

**Requires iOS 13.4, iPadOS 13.4 or MacOS Big Sur
</details>

<details>
<summary><strong>11.1</strong></summary>    

![Released](https://img.shields.io/badge/Released-blue.svg?style=flat)
### Bug Fixes
- Fixed the bug which caused the labels on posts to be hidden

### New Features
#### Spotlight search support
- Search and preview announcements using spotlight search
- Tap on the search result to open it up in SST Announcer

</details>

<details>
<summary><strong>11.0.1</strong></summary>

![EOL](https://img.shields.io/badge/End--Of--Life-critical.svg?style=flat)
### Bug fixes
- Fixed bug where certain notifications would not be sent to the user
- Fixed bug where the content of the post would not show up on the notification
- Fixed bug which caused certain links to result in an error 404 screen. Now, those links just redirect to the Students Blog.

### New Features
#### Improved Links and Labels 
- Dynamically shows and hides when switching device orientation to optimise for space
</details>

<details>
<summary><strong>11.0</strong></summary>

![EOL](https://img.shields.io/badge/End--Of--Life-critical.svg?style=flat)
### New Features
#### Dark mode*
- Announcer now has dark mode! Experience dark mode on Announcer by turning it on in Settings app > Display & Brightness > select Dark

#### Peek & Pop
- Easily preview announcements and access quick actions such as Pin and Share

#### Haptic Feedback**
- We have added haptic feedback for certain actions and interactions within the app

#### Filter Posts with Labels
- Find posts using Labels! From Announcer, tap on the filter button and select which label you would like to use. 
- You can also type “[Label Name]” into the search field for example, “[10th Anniversary]”.

#### Sharing Posts
- Previously, sharing a post meant sharing an entire chunk of text. Now, the app shares the Students’ Blog link.

#### Notifications
- Notifications have been fixed. You can now get push notifications for every new announcement.

#### User Experience improvements
- Scroll up to easily select the items at the top of the screen. No need to stretch to reach the buttons.

#### Accessibility improvements
- Made it easier to increase your text size by pinching and zooming. Previously, it required a double-tap.

#### Colours
- We switched from a Red theme to a Blue one to better match the app.

#### Links
- There is now a dedicated links section at the bottom of the post for you to select a link easily

*feature is only available on iOS 13.0 or later

**feature requires compatible device
</details>
