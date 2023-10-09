//
//  AppDelegate.swift
//  Argon
//
//  Created by Vincent Coetzee on 2022/11/05.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate
    {
    func applicationWillFinishLaunching(_ notification: Notification)
        {
        let _ = ArgonDocumentController()
        }
    
    func applicationDidFinishLaunching(_ aNotification: Notification)
        {
        ArgonTests.runTests()
        }

    func applicationWillTerminate(_ aNotification: Notification)
        {
        // Insert code here to tear down your application
        }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool
        {
        return true
        }
    }

