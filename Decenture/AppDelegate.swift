//
//  AppDelegate.swift
//  Decenture
//
//  Created by Nathan Dane on 21/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit
import stellarsdk

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    window = UIWindow(frame: UIScreen.main.bounds)
    
    let navigationController =  UINavigationController(rootViewController: TransactionHistoryViewController())
    navigationController.isNavigationBarHidden = true
    
    getAccount {
      self.window?.rootViewController = navigationController
      self.window?.makeKeyAndVisible()
    }

    return true
  }
  
  private func getAccount(_ completion: @escaping () -> Void) {
    let mnemonic = UserDefaults.standard.string(forKey: "mnemonic") ?? Wallet.generate24WordMnemonic()
    UserDefaults.standard.set(mnemonic, forKey: "mnemonic")

    let accountAlreadyCreated = UserDefaults.standard.bool(forKey: "created")
    
    do {
      let keyPair = try Wallet.createKeyPair(mnemonic: mnemonic, passphrase: nil, index: 0)
      Account.shared.keyPair = keyPair

      if accountAlreadyCreated == false {
        let stellar = StellarManager.shared.stellar

        stellar.accounts.createTestAccount(accountId: keyPair.accountId) { response in
          switch response {
          case .success:
            UserDefaults.standard.set(true, forKey: "created")
            DispatchQueue.main.async(execute: completion)

          case .failure(let error):
            print(error.localizedDescription)
          }
        }
      } else {
        completion()
      }
    } catch {
      print("\(error.localizedDescription)")
    }
  }

}
