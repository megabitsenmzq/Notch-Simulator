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
    @IBOutlet weak var tapeImage: NSImageView!
    @IBOutlet weak var lightImage: NSImageView!
    @IBOutlet weak var buttonView: NSStackView!
    var mouseTracking: NSTrackingArea?
    
    let updateCameraToggledNotification = Notification.Name("cameraToggled")
    let updateImageNotification = Notification.Name("bigNotchToggled")

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        updateCamera()
        NotificationCenter.default.addObserver(forName: updateCameraToggledNotification, object: nil, queue: nil) { _ in
            self.updateCamera()
        }
        
        updateNotchImage()
        NotificationCenter.default.addObserver(forName: updateImageNotification, object: nil, queue: nil, using: { _ in
            self.updateNotchImage()
        })
    }
    
    func updateCamera() {
        guard let screenNumber = view.window?.screen?.deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? NSNumber else { return }
        let isBuildin = CGDisplayIsBuiltin(screenNumber.uint32Value)
        
        cameraImage.isHidden = !isCameraEnabled || (isBuildin != 0 && isCameraExternalOnly)
        lightImage.isHidden = !isCameraEnabled || !isCameraOn || (isBuildin != 0 && isCameraExternalOnly)
        tapeImage.isHidden = !isTapeOn || !isCameraEnabled || (isBuildin != 0 && isCameraExternalOnly)
    }
    
    func updateNotchImage() {
        if tapeID == 0 { tapeID += 1 }
        
        centerImage.image = isShowBigNotch ? NSImage(named: "bigNotch") : NSImage(named: "notch")
        cameraImage.image = isShowBigNotch ? NSImage(named: "bigCamera") : NSImage(named: "camera")
        lightImage.image = isShowBigNotch ? NSImage(named: "bigCameraLight") : NSImage(named: "cameraLight")
        tapeImage.image = isShowBigNotch ? NSImage(named: "bigTape\(tapeID)") : NSImage(named: "tape\(tapeID)")
        
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
    
    @IBAction func showMoreMenu(_ sender: NSButton) {
        let menu = moreMenu()
        let point = NSPoint(x: 0, y: sender.frame.maxY + 5)
        menu.popUp(positioning: nil, at:point, in: sender)
    }
    
}


// MARK: - Menu

extension NotchViewController {
    
    func moreMenu() -> NSMenu {
        let moreMenu = NSMenu()
        
        let runAtLoginItem = NSMenuItem(title: NSLocalizedString("Run at login", comment: ""), action: #selector(changeRunAtLogin), keyEquivalent: "")
        runAtLoginItem.state = isRunAtLoginEnabled ? .on : .off
        runAtLoginItem.target = self
        moreMenu.addItem(runAtLoginItem)
        
        moreMenu.addItem(NSMenuItem.separator())
        
        let showCameraItem = NSMenuItem(title: NSLocalizedString("Show camera", comment: ""), action: #selector(showCamera), keyEquivalent: "")
        showCameraItem.state = isCameraEnabled ? .on : .off
        showCameraItem.target = self
        moreMenu.addItem(showCameraItem)
        
        let turnOnCameraItem = NSMenuItem(title: NSLocalizedString("Turn on the camera", comment: ""), action: #selector(turnOnCamera), keyEquivalent: "")
        turnOnCameraItem.state = isCameraOn ? .on : .off
        turnOnCameraItem.isEnabled = isCameraEnabled
        if isCameraEnabled {
            turnOnCameraItem.target = self
        }
        moreMenu.addItem(turnOnCameraItem)
        
        let showTapeItem = NSMenuItem(title: NSLocalizedString("Put tape on it!", comment: ""), action: #selector(showTape), keyEquivalent: "")
        showTapeItem.state = isTapeOn ? .on : .off
        if isCameraEnabled {
            showTapeItem.target = self
        }
        moreMenu.addItem(showTapeItem)
        
        let externalOnlyItem = NSMenuItem(title: NSLocalizedString("Camera for external only", comment: ""), action: #selector(cameraExternalOnly), keyEquivalent: "")
        externalOnlyItem.state = isCameraExternalOnly ? .on : .off
        if isCameraEnabled {
            externalOnlyItem.target = self
        }
        moreMenu.addItem(externalOnlyItem)
        
        moreMenu.addItem(NSMenuItem.separator())
        
        let notchInternalOnlyItem = NSMenuItem(title: NSLocalizedString("Notch for internal only", comment: ""), action: #selector(notchInternalOnly), keyEquivalent: "")
        notchInternalOnlyItem.state = isNotchInternalOnly ? .on : .off
        if NSScreen.haveBuiltinScreen {
            notchInternalOnlyItem.target = self
        }
        moreMenu.addItem(notchInternalOnlyItem)
        
        let showInMissionControlItem = NSMenuItem(title: NSLocalizedString("Visible in Mission Control", comment: ""), action: #selector(showInMissionControl), keyEquivalent: "")
        showInMissionControlItem.state = isShowInMissionControl ? .on : .off
        showInMissionControlItem.target = self
        moreMenu.addItem(showInMissionControlItem)
        
        let showBigNotchItem = NSMenuItem(title: NSLocalizedString("Bigger than Bigger", comment: ""), action: #selector(showBigNotch), keyEquivalent: "")
        showBigNotchItem.state = isShowBigNotch ? .on : .off
        showBigNotchItem.target = self
        moreMenu.addItem(showBigNotchItem)
        
        moreMenu.addItem(NSMenuItem.separator())
        
        let githubItem = NSMenuItem(title: NSLocalizedString("GitHub Page", comment: ""), action: #selector(github), keyEquivalent: "")
        githubItem.target = self
        moreMenu.addItem(githubItem)
        
        let twitterItem = NSMenuItem(title: NSLocalizedString("My Twitter", comment: ""), action: #selector(twitter), keyEquivalent: "")
        twitterItem.target = self
        moreMenu.addItem(twitterItem)
        
        let myAppsItem = NSMenuItem(title: NSLocalizedString("My other apps", comment: ""), action: #selector(showApps), keyEquivalent: "")
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
        NotificationCenter.default.post(name: updateCameraToggledNotification, object: nil)
    }
    
    @objc func turnOnCamera() {
        isCameraOn.toggle()
        NotificationCenter.default.post(name: updateCameraToggledNotification, object: nil)
    }
    
    @objc func showTape() {
        isTapeOn.toggle()
        if isTapeOn {
            tapeID += 1
            if NSImage(named: "tape\(tapeID)") == nil { tapeID = 0 }
        }
        NotificationCenter.default.post(name: updateImageNotification, object: nil)
        NotificationCenter.default.post(name: updateCameraToggledNotification, object: nil)
    }
    
    @objc func cameraExternalOnly() {
        isCameraExternalOnly.toggle()
        if isCameraExternalOnly {
            isNotchInternalOnly = false
            if let delegate = NSApplication.shared.delegate as? AppDelegate {
                delegate.resetWindow()
            }
        }
        NotificationCenter.default.post(name: updateCameraToggledNotification, object: nil)
    }
    
    @objc func notchInternalOnly() {
        isNotchInternalOnly.toggle()
        if isNotchInternalOnly {
            isCameraExternalOnly = false
            NotificationCenter.default.post(name: updateCameraToggledNotification, object: nil)
        }
        if let delegate = NSApplication.shared.delegate as? AppDelegate {
            delegate.resetWindow()
        }
    }
    
    @objc func showInMissionControl() {
        isShowInMissionControl.toggle()
        if let delegate = NSApplication.shared.delegate as? AppDelegate {
            delegate.resetWindow()
        }
    }
    
    @objc func showBigNotch() {
        isShowBigNotch.toggle()
        NotificationCenter.default.post(name: updateImageNotification, object: nil)
    }
    
    @objc func github() {
        NSWorkspace.shared.open(URL(string: "https://github.com/megabitsenmzq/Notch-Simulator")!)
    }
    
    @objc func twitter() {
        NSWorkspace.shared.open(URL(string: "https://twitter.com/Megabits_mzq")!)
    }
    
    @objc func showApps() {
        if let delegate = NSApplication.shared.delegate as? AppDelegate {
            delegate.setupMyAppWindow()
        }
    }
    
}
