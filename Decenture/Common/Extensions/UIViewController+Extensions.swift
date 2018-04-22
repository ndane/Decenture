//
//  UIViewController+Extensions.swift
//  Decenture
//
//  Created by Nathan Dane on 22/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit

extension UIViewController {
  
  func presentAlert(text: String) {
    let alert = UIAlertController(title: "Error", message: text, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
    present(alert, animated: true)
  }
  
}
