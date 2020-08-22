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
import SafariServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window`
        // to the provided UIWindowScene `scene`.
        //
        // If using a storyboard, the `window` property will automatically be
        // initialized and attached to the scene.
        //
        // This delegate does not imply the connecting scene or session are
        // new (see `application:configurationForConnectingSceneSession` instead).
        if scene as? UIWindowScene == nil { return }
        
        if !I.phone {
            window?.rootViewController = Storyboards.main.instantiateViewController(withIdentifier: "master")
        }
        
        if let userActivity = userActivity {
            continueFromCoreSpotlight(with: userActivity)
        }
        
        // Determine who sent the URL.
        if let urlContext = connectionOptions.urlContexts.first {
            openFrom(urlContext: urlContext)
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let urlContext = URLContexts.first {
            openFrom(urlContext: urlContext)
        }
        
    }
    
    func openFrom(urlContext: UIOpenURLContext) {
        let timetableVC = Storyboards.timetable.instantiateInitialViewController()
        
        let sendingAppID = urlContext.options.sourceApplication
        let url = urlContext.url
        print("source application = \(sendingAppID ?? "Unknown")")
        print("url = \(url)")
        
        let rootVC = UIApplication.shared.windows.first?.rootViewController
        var presentationVC: UIViewController? 
        
        switch url.absoluteString {
        case "sstannouncer://launchwidget":
            // User launched from widget, handle from widget
            if #available(iOS 14, *) {
                presentationVC = timetableVC!
            }
            
        case "sstannouncer://diagnostics":
            let vc = Storyboards.diagnostics.instantiateInitialViewController()
            
            window?.rootViewController = vc
        default:
            if url.absoluteString.hasPrefix("sstannouncer://post/") {
                var urlString = url.absoluteString
                urlString.removeFirst("sstannouncer://post/".count)
                let regex = try? NSRegularExpression(pattern: "[0-9]",
                                                     options: .caseInsensitive)
                
                // Make sure it is valid
                if (regex?.matches(in: urlString,
                                   options: .withTransparentBounds,
                                   range: .init(location: 0,
                                                length: urlString.count)).count)! > 0 {
                    
                    // Launch post
                    DispatchQueue.main.async {
                        launch(getPost(fromLink: urlString))
                    }
                }
            } else {
                // I have the best error messages.
                
                // Never gonna give you up
                let svc = SFSafariViewController(url: URL(string: "https://www.youtube.com/embed/dQw4w9WgXcQ")!)
                
                // easter egg
                presentationVC = svc
            }
        }
        
        if let presentationVC = presentationVC {
            DispatchQueue.main.async {
                rootVC?.present(presentationVC,
                                animated: true,
                                completion: nil)
            }
        }
    }
    
    // Handling when user opens from spotlight search
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        continueFromCoreSpotlight(with: userActivity)
    }
    
    func scene(_ scene: UIScene, didUpdate userActivity: NSUserActivity) {
        continueFromCoreSpotlight(with: userActivity)
    }
    
}
