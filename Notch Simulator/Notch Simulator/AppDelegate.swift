//
//  AppDelegate.swift
//  Notch Simulator
//
//  Created by Jinyu Meng on 2021/10/19.
//

import Cocoa

var isRunAtLoginEnabled = UserDefaults.standard.bool(forKey: "pref.RunAtLogin") {
    didSet { UserDefaults.standard.setValue(isRunAtLoginEnabled, forKey: "pref.RunAtLogin") }}

var isCameraEnabled = UserDefaults.standard.bool(forKey: "pref.isCameraEnabled") {
    didSet { UserDefaults.standard.setValue(isCameraEnabled, forKey: "pref.isCameraEnabled") }}

var isCameraOn = UserDefaults.standard.bool(forKey: "pref.isCameraOn") {
    didSet { UserDefaults.standard.setValue(isCameraOn, forKey: "pref.isCameraOn") }}

var isTapeOn = UserDefaults.standard.bool(forKey: "pref.isTapeOn") {
    didSet { UserDefaults.standard.setValue(isTapeOn, forKey: "pref.isTapeOn") }}

var tapeID = UserDefaults.standard.integer(forKey: "pref.tapeID") {
    didSet { UserDefaults.standard.setValue(tapeID, forKey: "pref.tapeID") }}

var isCameraExternalOnly = UserDefaults.standard.bool(forKey: "pref.isCameraExternalOnly") {
    didSet { UserDefaults.standard.setValue(isCameraExternalOnly, forKey: "pref.isCameraExternalOnly") }}

var isNotchInternalOnly = UserDefaults.standard.bool(forKey: "pref.isNotchInternalOnly") {
    didSet { UserDefaults.standard.setValue(isNotchInternalOnly, forKey: "pref.isNotchInternalOnly") }}

var isShowInMissionControl = !UserDefaults.standard.bool(forKey: "pref.isShowInMissionControl") {
    didSet { UserDefaults.standard.setValue(!isShowInMissionControl, forKey: "pref.isShowInMissionControl") }}

var isShowBigNotch = UserDefaults.standard.bool(forKey: "pref.isShowBigNotch") {
    didSet { UserDefaults.standard.setValue(isShowBigNotch, forKey: "pref.isShowBigNotch") }}

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    let screens = NSScreen.screens
    var windows = [NotchWindow]()
    var windowControllers = [NSWindowController]()
    let notchViewController = NotchViewController(nibName: "NotchViewController", bundle: nil)
    
    let myAppsWindow = NSWindow()
    let myAppsWindowController = NSWindowController()
    let myAppsViewController = MyAppsViewController(nibName: "MyAppsViewController", bundle: nil)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        setupWindow()
        
        NotificationCenter.default.addObserver(self, selector: #selector(resetWindow), name: NSApplication.didChangeScreenParametersNotification, object: nil)
        
        if !UserDefaults.standard.bool(forKey: "showMyApps") {
            setupMyAppWindow()
            UserDefaults.standard.set(true, forKey: "showMyApps")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    
    func setupWindow() {
        if screens.count == 0 {
            NSApplication.shared.terminate(self)
        }
        
        for i in 0..<screens.count {
            if !screens[i].isBuiltinScreen && (isNotchInternalOnly && NSScreen.haveBuiltinScreen) { continue }
            
            let notchWindow = NotchWindow()
            notchWindow.targetScreen = screens[i]
            notchWindow.styleMask = .borderless
            notchWindow.backingType = .buffered
            notchWindow.backgroundColor = .clear
            notchWindow.hasShadow = false
            notchWindow.level = .screenSaver
            if isShowInMissionControl {
                notchWindow.collectionBehavior =  [.canJoinAllSpaces, .fullScreenNone, .stationary]
            } else {
                notchWindow.collectionBehavior =  [.canJoinAllSpaces, .fullScreenNone]
            }
            notchWindow.contentViewController = NotchViewController(nibName: "NotchViewController", bundle: nil)
            
            let screenFrame = screens[i].frame
            notchWindow.setFrame(NSRect(x: screenFrame.origin.x, y: screenFrame.origin.y + screenFrame.size.height - 100, width: screenFrame.size.width, height: 100), display: true)
            
            let notchWindowController = NSWindowController()
            notchWindowController.contentViewController = notchWindow.contentViewController
            notchWindowController.window = notchWindow
            notchWindowController.showWindow(self)
            
            windows.append(notchWindow)
            windowControllers.append(notchWindowController)
        }
    }
    
    @objc func resetWindow() {
        for item in windows {
            item.close()
        }
        
        windows.removeAll()
        windowControllers.removeAll()
        
        setupWindow()
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

