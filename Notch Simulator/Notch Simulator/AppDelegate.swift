//
//  AppDelegate.swift
//  Notch Simulator
//
//  Created by Jinyu Meng on 2021/10/19.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {


    let notchWindow = NSWindow()
    let notchWindowController = NSWindowController()
    let notchViewController = NotchViewController(nibName: "NotchViewController", bundle: nil)
    
    let myAppsWindow = NSWindow()
    let myAppsWindowController = NSWindowController()
    let myAppsViewController = MyAppsViewController(nibName: "MyAppsViewController", bundle: nil)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupWindow()
        
        if !UserDefaults.standard.bool(forKey: "viewMyApps") {
            setupMyAppWindow()
            UserDefaults.standard.set(true, forKey: "viewMyApps")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    
    func setupWindow() {
        notchWindow.styleMask = .borderless
        notchWindow.backingType = .buffered
        notchWindow.backgroundColor = .clear
        notchWindow.hasShadow = false
        notchWindow.level = .screenSaver
        notchWindow.contentViewController = notchViewController
        
        NotificationCenter.default.addObserver(self, selector: #selector(resizeWindow), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        resizeWindow()
        
        notchWindowController.contentViewController = notchWindow.contentViewController
        notchWindowController.window = notchWindow
        notchWindowController.showWindow(self)
    }
    
    @objc func resizeWindow() {
        let screenSize = NSScreen.main!.frame.size
        let menubarHeight = NSApplication.shared.mainMenu!.menuBarHeight

        for s in NSScreen.screens {
            let n = s.deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as! NSNumber
            let isBuildin = CGDisplayIsBuiltin(n.uint32Value)
            if (isBuildin != 0) {
                screenSize = s.frame.size
            }
        }
        
        notchWindow.setFrame(NSRect(x: screenSize.width / 2 - 100, y: screenSize.height - menubarHeight, width: 200, height: menubarHeight), display: true)
    }

    
    func setupMyAppWindow() {
        myAppsWindow.styleMask = [.titled, .closable]
        myAppsWindow.backingType = .buffered
        myAppsWindow.title = "MyApps"
        myAppsWindow.contentViewController = myAppsViewController
        myAppsWindowController.contentViewController = myAppsWindow.contentViewController
        myAppsWindowController.window = myAppsWindow
        myAppsWindowController.showWindow(self)
        
        myAppsWindow.center()
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
}

