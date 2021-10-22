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
    
    @IBAction func openMDClockLink(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://apps.apple.com/app/apple-store/id1536358464?pt=119361776&ct=megbits&mt=8")!)
    }
    
    @IBAction func openBaiMiaoLink(_ sender: Any) {
        NSWorkspace.shared.open(URL(string: "https://baimiao.uzero.cn")!)
    }
    
    @IBAction func close(_ sender: Any) {
        view.window?.close()
    }
}
