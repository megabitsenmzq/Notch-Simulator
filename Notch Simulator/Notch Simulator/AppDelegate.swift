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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NSApplicationDidChangeScreenParametersNotification"), object: nil)
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        resizeWindow();
    }
    
    func setupWindow() {
        notchWindow.styleMask = .borderless
        notchWindow.backingType = .buffered
        notchWindow.backgroundColor = .clear
        notchWindow.hasShadow = false
        notchWindow.level = .screenSaver
        notchWindow.contentViewController = notchViewController
        
        resizeWindow();
        
        notchWindowController.contentViewController = notchWindow.contentViewController
        notchWindowController.window = notchWindow
        notchWindowController.showWindow(self)
    }

    func resizeWindow(){
        let screenSize = NSScreen.main!.frame.size
        let menubarHeight = NSApplication.shared.mainMenu!.menuBarHeight
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

