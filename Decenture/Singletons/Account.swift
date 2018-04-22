//
//  Account.swift
//  Decenture
//
//  Created by Nathan Dane on 22/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import Foundation
import stellarsdk

struct Account {
  
  static var shared: Account = {
    return Account()
  }()
  
  var keyPair: KeyPair?
  
}
