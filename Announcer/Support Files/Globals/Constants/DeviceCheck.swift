//
//  DeviceCheck.swift
//  Announcer
//
//  Created by JiaChen(: on 31/7/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import Foundation
import UIKit

/**
Checking platform, this handles iOS 13 and 14.

# Check if user is on MacOS
```swift
if I.mac {
    // run code just for Mac
}
```

# Check if user is on iPadOS
```swift
if I.wantToBeMac {
    // run code just for iPad
}
```

# Check if user is on iOS
```swift
if I.Phone {
    // run code just for iPhone
}
```

# Better way to crash
Let's be real, this is the best way to terminate a program
```swift
I.wantToDie
```
*/
// swiftlint:disable:next type_name
struct I {
    /// Check if device is a Mac
    static let mac: Bool = {
        if #available(iOS 14.0, *) {
            return UIDevice.current.userInterfaceIdiom == .mac
        } else {
            #if targetEnvironment(macCatalyst)
            return true
            #else
            return false
            #endif
        }
    }()
    
    /// Check if device is an iPad
    static let wantToBeMac: Bool = {
        #if targetEnvironment(macCatalyst)
        return false
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
        #endif
    }()
    
    /// Check if device is an iPhone
    static let phone: Bool = {
        UIDevice.current.userInterfaceIdiom == .phone
    }()
    
    /// I want to die
    static var wantToDie: Never {
        fatalError("I want to die")
    }
}
