//
//  Extensions.swift
//  TrueFalseStarter
//
//  Created by Brandon Mahoney on 2/19/20.
//  Copyright © 2020 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit


//extension UIColor {
//    convenience init(hex: String, alpha: CGFloat = 1) {
//        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
//        
//        let scanner = Scanner(string: hex)
//        scanner.scanLocation = 1  // skip #
//        
//        var rgb: UInt32 = 0
//        scanner.scanHexInt32(&rgb)
//        
//        self.init(
//            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
//            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
//            blue:  CGFloat((rgb &     0xFF)      )/255.0,
//            alpha: alpha)
//    }
//}

//MARK: - UIColor from hex
public extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex = String(hex[index...])
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
