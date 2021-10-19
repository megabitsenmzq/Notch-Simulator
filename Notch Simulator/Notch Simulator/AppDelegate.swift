//
//  AppDelegate.swift
//  Notch Simulator
//
//  Created by 孟金羽 on 2021/10/19.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {


    let notchWindow = NSWindow()
    let notchWindowController = NSWindowController()
    let notchViewController = NotchViewController(nibName: "NotchViewController", bundle: nil)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupWindow()
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
        
        notchWindowController.contentViewController = notchWindow.contentViewController
        notchWindowController.window = notchWindow
        notchWindowController.showWindow(self)
        
        resizeWindow();
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NSApplicationDidChangeScreenParametersNotification"), object: nil)
         
        
    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        resizeWindow();
    }
    func resizeWindow(){
        let screenSize = NSScreen.main!.frame.size
        let menubarHeight = NSApplication.shared.mainMenu!.menuBarHeight
        notchWindow.setFrame(NSRect(x: screenSize.width / 2 - 100, y: screenSize.height - menubarHeight, width: 200, height: menubarHeight), display: true)
    }

}

