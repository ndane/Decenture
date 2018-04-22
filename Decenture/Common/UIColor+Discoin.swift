//
//  UIColor+Discoin.swift
//  Decenture
//
//  Created by Nathan Dane on 22/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit

public struct DiscoinColors {
  
  public static var green: UIColor {
    return UIColor(rgbaValue: 0x86CA6fFF)
  }
  
  public static var lightGrey: UIColor {
    return UIColor(rgbaValue: 0xF2F2F2FF)
  }
  
  public static var greyBlue: UIColor {
    return UIColor(rgbaValue: 0x7A979CFF)
  }
  
}

extension UIColor {
  
  public static var discoin: DiscoinColors.Type {
    return DiscoinColors.self
  }
  
}
