//
//  DiagnosticsViewController.swift
//  Announcer
//
//  Created by JiaChen(: on 3/8/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import UIKit
import WidgetKit

class DiagnosticsViewController: UIViewController {

    @IBOutlet weak var diagnosticsTextView: UITextView!
    
    var fullReport: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        diagnosticsTextView.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .medium)
        
        DispatchQueue.global(qos: .default).async {
            let report = self.generateReport()
            
            self.fullReport = report
            DispatchQueue.main.async {
                self.diagnosticsTextView.text = report
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "SST Announcer Diagnostics Tool",
                                      message: """

This tool is used to generate diagnostics reports for SST Announcer.
The report has 3 main sections - Announcer information, Device information and Data dump.

The report generated on SST Announcer is not shared with anyone until you choose to do so.

If you are a user who just found this by accident, congrats.
You can look through all this interesting information collected with SST Announcer.

If you are here for debugging or reporting a bug, you're in the right place.

Information in report:

*Announcer Information*
- App version
- Build number
- Debug or Release
- Report Identifier (a unique identifier assigned to every report)
- Report Date and Time (Exact date and time when report was created)

*Device Information*
- Operating System (iOS, iPadOS or MacOS)
- Model (iPhone, iPad, iPod, Mac, etc.)
- Battery Level
- Battery Charging
- Battery Unplugged
- Battery Full

*Data Dump*
- Pinned Announcements
- Read Announcements
- Timetables

*Widgets*
- Kind
- Configuration
- Family (Small or Medium)
- Reload Time (The date that the widget was refreshed)

If you would like to exit, press X, restart SST Announcer or press Cancel.
""", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            self.closeApp(self)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getFiles() -> String {
        let encoder = JSONEncoder()
        let encodedPins = try? String(data: encoder.encode(PinnedAnnouncements.loadFromFile()), encoding: .utf8)
        let encodedRead = try? String(data: encoder.encode(ReadAnnouncements.loadFromFile()), encoding: .utf8)
        
        let defaults = UserDefaults(suiteName: "group.SST-singapore.Timetables")
        let encodedTimetable = defaults?.string(forKey: "TT")
        
        let dataDumpOut = """
DATA DUMP
-----------------------------------------------

Pinned Posts
\(encodedPins ?? "no data")


Read Posts
\(encodedRead ?? "no data")


Timetable
\(encodedTimetable ?? "no data")
"""
        
        return dataDumpOut
    }
    
    func deviceInfo() -> String {
        let device = UIDevice.current
        
        return """

Device Information
|
| OS Name: \(device.systemName)
|
| OS Version: \(device.systemVersion)
|
| Model: \(device.model)
|
| Battery
    | Level: \(device.batteryLevel)
    |
    | Charging: \(device.batteryState == .charging)
    |
    | Unplugged: \(device.batteryState == .unplugged)
    |
    | Full: \(device.batteryState == .full)
"""
    }
    
    func isDebug() -> String {
        #if DEBUG
        return "DEBUG"
        #else
        return "RELEASE"
        #endif
    }
    
    func generateReport() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd • HH:mm:ss • Z"
        
        let report = """
           SST ANNOUNCER DIAGNOSTICS
-----------------------------------------------

Report Information
|
| Date Generated: \(formatter.string(from: Date()))
|
| ID: \(UUID().uuidString)

-----------------------------------------------

SST Announcer Information
|
| App Version: \(UserDefaults.standard.string(forKey: UserDefaultsIdentifiers.versionNumber.rawValue)!)
|
| App Build: \(UserDefaults.standard.string(forKey: UserDefaultsIdentifiers.buildNumber.rawValue)!)
|
| Type : \(isDebug())

-----------------------------------------------

\(deviceInfo())

-----------------------------------------------

\(getFiles())

"""
        return report
    }
    
    @IBAction func export(_ sender: Any) {
        let activityViewController = UIActivityViewController(activityItems: [fullReport ?? ""],
                                                              applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    @IBAction func closeApp(_ sender: Any) {
        // home button pressed programmatically - to thorw app to background
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        
        // terminaing app in background
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            exit(EXIT_SUCCESS)
        })
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
