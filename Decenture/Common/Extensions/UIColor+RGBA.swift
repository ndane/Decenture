//
//  UIColor+RGBA.swift
//  Decenture
//
//  Created by Nathan Dane on 22/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit

extension UIColor {
  convenience public init(rgbaValue: UInt32) {
    let red = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue = CGFloat((rgbaValue >> 8) & 0xff) / 255.0
    let alpha = CGFloat(rgbaValue & 0xff) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
