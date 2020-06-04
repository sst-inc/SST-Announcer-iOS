//
//  SceneDelegate.swift
//  Announcer
//
//  Created by JiaChen(: on 25/11/19.
//  Copyright © 2019 SST Inc. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if UIDevice.current.userInterfaceIdiom != .phone {
            window?.rootViewController = Storyboards.main.instantiateViewController(withIdentifier: "master")
        }
        
    }
    
    // Handling when user opens from spotlight search
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        continueFromCoreSpotlight(with: userActivity)
    }
}

