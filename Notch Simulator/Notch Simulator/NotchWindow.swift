//
//  NotchWindow.swift
//  Notch Simulator
//
//  Created by 孟金羽 on 2021/10/19.
//

import Cocoa

class NotchWindow: NSWindow {
    var targetScreen: NSScreen!
    
    override func constrainFrameRect(_ frameRect: NSRect, to screen: NSScreen?) -> NSRect {
        return super.constrainFrameRect(frameRect, to: targetScreen)
    }
}
