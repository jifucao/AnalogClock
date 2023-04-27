//
//  AppDelegate.swift
//  AnalogClock
//
//  Created by Jifu Cao on 2023/4/26.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        let clockView = AnalogClockView()
        
        window.contentView = clockView
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            clockView.currentTime = .now
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }


}

