//
//  StellarManager.swift
//  Decenture
//
//  Created by Nathan Dane on 22/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import Foundation
import stellarsdk

struct StellarManager {

  static var shared: StellarManager = {
    return StellarManager()
  }()

  let stellar: StellarSDK

  init() {
    stellar = StellarSDK(withHorizonUrl: "https://horizon-testnet.stellar.org")
  }

}
