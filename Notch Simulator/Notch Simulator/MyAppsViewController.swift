//
//  MyAppsViewController.swift
//  Notch Simulator
//
//  Created by Jinyu Meng on 2021/10/19.
//

import Cocoa

class MyAppsViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func openTomoNowLink(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://apps.apple.com/us/app/id1505296579")!)
    }
    @IBAction func openMagicShareLink(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://apps.apple.com/us/app/id1438149621")!)
    }
    @IBAction func close(_ sender: Any) {
        view.window?.close()
    }
}
