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
    @IBOutlet weak var lightImage: NSImageView!
    @IBOutlet weak var buttonView: NSStackView!
    var mouseTracking: NSTrackingArea?
    
    let cameraToggledNotification = Notification.Name("cameraToggled")
    let bigNotchToggledNotification = Notification.Name("bigNotchToggled")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        updateCamera()
        NotificationCenter.default.addObserver(forName: cameraToggledNotification, object: nil, queue: nil) { _ in
            self.updateCamera()
        }
        
        updateNotchImage()
        NotificationCenter.default.addObserver(forName: bigNotchToggledNotification, object: nil, queue: nil, using: { _ in
            self.updateNotchImage()
        })
    }
    
    func updateCamera() {
        guard let screenNumber = view.window?.screen?.deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? NSNumber else { return }
        let isBuildin = CGDisplayIsBuiltin(screenNumber.uint32Value)
        
        cameraImage.isHidden = !isCameraEnabled || (isBuildin != 0 && isCameraExternalOnly)
        lightImage.isHidden = !isCameraEnabled || !isCameraOn || (isBuildin != 0 && isCameraExternalOnly)
    }
    
    func updateNotchImage() {
        centerImage.image = isShowBigNotch ? NSImage(named: "bigNotch") : NSImage(named: "notch")
        cameraImage.image = isShowBigNotch ? NSImage(named: "bigCamera") : NSImage(named: "camera")
        lightImage.image = isShowBigNotch ? NSImage(named: "bigCameraLight") : NSImage(named: "cameraLight")
        
        DispatchQueue.main.async {
            self.startMouseTracking()
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
        for item in view.trackingAreas {
            view.removeTrackingArea(item)
        }
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
        
        moreMenu.addItem(NSMenuItem.separator())
        
        let showCameraItem = NSMenuItem(title: "Show camera", action: #selector(showCamera), keyEquivalent: "")
        showCameraItem.state = isCameraEnabled ? .on : .off
        showCameraItem.target = self
        moreMenu.addItem(showCameraItem)
        
        let turnOnCameraItem = NSMenuItem(title: "Turn on the camera", action: #selector(turnOnCamera), keyEquivalent: "")
        turnOnCameraItem.state = isCameraOn ? .on : .off
        turnOnCameraItem.isEnabled = isCameraEnabled
        if isCameraEnabled {
            turnOnCameraItem.target = self
        }
        moreMenu.addItem(turnOnCameraItem)
        
        let externalOnlyItem = NSMenuItem(title: "Camera for external only", action: #selector(cameraExternalOnly), keyEquivalent: "")
        externalOnlyItem.state = isCameraExternalOnly ? .on : .off
        if isCameraEnabled {
            externalOnlyItem.target = self
        }
        moreMenu.addItem(externalOnlyItem)
        
        moreMenu.addItem(NSMenuItem.separator())
        
        let notchInternalOnlyItem = NSMenuItem(title: "Notch for internal only", action: #selector(notchInternalOnly), keyEquivalent: "")
        notchInternalOnlyItem.state = isNotchInternalOnly ? .on : .off
        notchInternalOnlyItem.target = self
        moreMenu.addItem(notchInternalOnlyItem)
        
        let showBigNotchItem = NSMenuItem(title: "Bigger than Bigger", action: #selector(showBigNotch), keyEquivalent: "")
        showBigNotchItem.state = isShowBigNotch ? .on : .off
        showBigNotchItem.target = self
        moreMenu.addItem(showBigNotchItem)
        
        moreMenu.addItem(NSMenuItem.separator())
        
        let githubItem = NSMenuItem(title: "GitHub Page", action: #selector(github), keyEquivalent: "")
        githubItem.target = self
        moreMenu.addItem(githubItem)
        
        let myAppsItem = NSMenuItem(title: "My other apps", action: #selector(showApps), keyEquivalent: "")
        myAppsItem.target = self
        moreMenu.addItem(myAppsItem)
        
        return moreMenu
    }
    
    
    @objc func changeRunAtLogin() {
        let helperBundleIdentifier = "com.JinyuMeng.Notch-Simulator-Helper"
        if SMLoginItemSetEnabled(helperBundleIdentifier as CFString, !isRunAtLoginEnabled) {
            isRunAtLoginEnabled.toggle()
        }
    }
    
    @objc func showCamera() {
        isCameraEnabled.toggle()
        NotificationCenter.default.post(name: cameraToggledNotification, object: nil)
    }
    
    @objc func turnOnCamera() {
        isCameraOn.toggle()
        NotificationCenter.default.post(name: cameraToggledNotification, object: nil)
    }
    
    @objc func cameraExternalOnly() {
        isCameraExternalOnly.toggle()
        if isCameraExternalOnly {
            isNotchInternalOnly = false
            if let delegate = NSApplication.shared.delegate as? AppDelegate {
                delegate.resetWindow()
            }
        }
        NotificationCenter.default.post(name: cameraToggledNotification, object: nil)
    }
    
    @objc func notchInternalOnly() {
        isNotchInternalOnly.toggle()
        if isNotchInternalOnly {
            isCameraExternalOnly = false
            NotificationCenter.default.post(name: cameraToggledNotification, object: nil)
        }
        if let delegate = NSApplication.shared.delegate as? AppDelegate {
            delegate.resetWindow()
        }
    }
    
    @objc func showBigNotch() {
        isShowBigNotch.toggle()
        NotificationCenter.default.post(name: bigNotchToggledNotification, object: nil)
    }
    
    @objc func github() {
        NSWorkspace.shared.open(URL(string: "https://github.com/megabitsenmzq/Notch-Simulator")!)
    }
    
    @objc func showApps() {
        if let delegate = NSApplication.shared.delegate as? AppDelegate {
            delegate.setupMyAppWindow()
        }
    }
    
}
