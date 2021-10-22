//
//  AppDelegate.swift
//  Notch Simulator
//
//  Created by ktiays on 2021/10/22.
//

import Cocoa

extension NSScreen {
    
    static var haveBuiltinScreen: Bool {
        NSScreen.screens.contains(where: { $0.isBuiltinScreen })
    }
    
    var isBuiltinScreen: Bool {
        guard let screenNumber = deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? NSNumber else {
            return false
        }
        return (CGDisplayIsBuiltin(screenNumber.uint32Value) != 0)
    }
    
}
