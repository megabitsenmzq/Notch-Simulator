//
//  NotchViewController.swift
//  Notch Simulator
//
//  Created by Jinyu Meng on 2021/10/19.
//

import Cocoa
import ServiceManagement

class NotchViewController: NSViewController {
    
    @IBOutlet weak var centerImage: NSImageView!
    @IBOutlet weak var cameraImage: NSImageView!
    @IBOutlet weak var buttonView: NSStackView!
    var mouseTracking: NSTrackingArea?
    
    let cameraToggledNotification = Notification.Name("cameraToggled")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        startMouseTracking()
        
        cameraImage.isHidden = !isCameraEnabled
        
        NotificationCenter.default.addObserver(forName: cameraToggledNotification, object: nil, queue: nil) { _ in
            self.cameraImage.isHidden = !isCameraEnabled
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        buttonView.isHidden = false
    }
    
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        buttonView.isHidden = true
    }
    
    func startMouseTracking(options: NSTrackingArea.Options = [.activeAlways, .mouseEnteredAndExited]) {
        let tracking = NSTrackingArea(rect: centerImage.frame, options: options, owner: self, userInfo: nil)
        view.addTrackingArea(tracking)
        mouseTracking = tracking
    }
    
    @IBAction func quit(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func showMoreMenu(_ sender: Any) {
        let menu = moreMenu()
        menu.popUp(positioning: nil, at: NSEvent.mouseLocation, in: nil)
    }
    
}


// MARK: - Menu

extension NotchViewController {
    
    func moreMenu() -> NSMenu {
        let moreMenu = NSMenu()
        
        let runAtLoginItem = NSMenuItem(title: "Run at login", action: #selector(changeRunAtLogin), keyEquivalent: "")
        runAtLoginItem.state = isRunAtLoginEnabled ? .on : .off
        runAtLoginItem.target = self
        moreMenu.addItem(runAtLoginItem)
        
        let showCameraItem = NSMenuItem(title: "Show camera", action: #selector(showCamera), keyEquivalent: "")
        showCameraItem.state = isCameraEnabled ? .on : .off
        showCameraItem.target = self
        moreMenu.addItem(showCameraItem)
        
        return moreMenu
    }
    
    
    @objc func changeRunAtLogin() {
        let helperBundleIdentifier = "com.JinyuMeng.Notch-Simulator-Helper"
        if SMLoginItemSetEnabled(helperBundleIdentifier as CFString, !isRunAtLoginEnabled) {
            isRunAtLoginEnabled.toggle()
        }
    }
    
    @objc func showCamera() {
        isCameraEnabled = !isCameraEnabled
        NotificationCenter.default.post(name: cameraToggledNotification, object: nil)
    }
    
}
