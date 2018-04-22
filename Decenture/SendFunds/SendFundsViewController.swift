//
//  SendFundsViewController.swift
//  Decenture
//
//  Created by Nathan Dane on 22/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit
import stellarsdk

class SendFundsViewController: UIViewController {
  
  // MARK: - UI Components
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 24, weight: .light)
    label.textColor = .white
    label.textAlignment = .center
    label.text = "Balance"
    return label
  }()
  
  private lazy var balanceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 64, weight: .light)
    label.textColor = .white
    label.textAlignment = .center
    label.text = "£0.00"
    return label
  }()
  
  private lazy var recepientTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .none
    textField.backgroundColor = UIColor.discoin.green
    textField.placeholder = "Recepient address"
    textField.textColor = .white
    textField.text = "GDCPVOF7VJ6S5WFQL7CGYZFN7SB7AOQ6QKQRAZ6FKWATJ7GGJTBTL5I5"
    return textField
  }()
  
  private lazy var amountTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .none
    textField.backgroundColor = UIColor.discoin.green
    textField.placeholder = "Amount"
    textField.textColor = .white
    return textField
  }()
  
  private lazy var messageTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .none
    textField.backgroundColor = UIColor.discoin.green
    textField.placeholder = "Message"
    textField.textColor = .white
    textField.addTarget(self, action: #selector(messageTextFieldDidReturn), for: .editingDidEndOnExit)
    return textField
  }()
  
  private lazy var sendButton: UIButton = {
    let button = UIButton()
    button.setTitle("Send it now", for: .normal)
    button.backgroundColor = .white
    button.setTitleColor(.gray, for: .normal)
    button.layer.cornerRadius = 4.0
    button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    return button
  }()
  
  private lazy var doneButton: UIButton = {
    let button = UIButton()
    button.setTitle("Done", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 4.0
    button.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    return button
  }()
  
  
  // MARK: - Lifecycle

  override func loadView() {
    super.loadView()
    
    view.backgroundColor = UIColor.discoin.green
    initLayout()
    makeConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loadDetails()
  }

  private func initLayout() {
    [ titleLabel,
      balanceLabel,
      recepientTextField,
      amountTextField,
      messageTextField,
      sendButton,
      doneButton ].forEach(view.addSubview(_:))
  }
  
  private func makeConstraints() {
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(55)
      make.leading.trailing.equalToSuperview()
    }
    
    balanceLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(20)
      make.leading.trailing.equalToSuperview()
      make.height.equalTo(50)
    }
    
    recepientTextField.snp.makeConstraints { make in
      make.top.equalTo(balanceLabel.snp.bottom).offset(70)
      make.leading.trailing.equalToSuperview().inset(50)
      make.height.equalTo(50)
    }
    
    amountTextField.snp.makeConstraints { make in
      make.top.equalTo(recepientTextField.snp.bottom).offset(25)
      make.leading.trailing.equalToSuperview().inset(50)
      make.height.equalTo(50)
    }
    
    messageTextField.snp.makeConstraints { make in
      make.top.equalTo(amountTextField.snp.bottom).offset(25)
      make.leading.trailing.equalToSuperview().inset(50)
      make.height.equalTo(50)
    }
    
    sendButton.snp.makeConstraints { make in
      make.top.equalTo(messageTextField.snp.bottom).offset(50)
      make.height.equalTo(44)
      make.width.equalTo(100)
      make.centerX.equalToSuperview()
    }
    
    doneButton.snp.makeConstraints { make in
      make.top.leading.equalTo(view.safeAreaLayoutGuide).inset(25)
      make.height.equalTo(44)
    }
  }
  
  // MARK: - UI Events
  
  @objc private func doneButtonPressed() {
    dismiss(animated: true, completion: nil)
  }
  
  @objc private func messageTextFieldDidReturn() {
    messageTextField.resignFirstResponder()
  }
  
  @objc private func sendButtonPressed() {
    guard let keyPair = Account.shared.keyPair else { return }
    let stellar = StellarManager.shared.stellar
    
    stellar.accounts.getAccountDetails(accountId: keyPair.accountId) { accountResponse in
      switch accountResponse {
      case .failure(let error):
        print(error.localizedDescription)
        
      case .success(let details):
        do {
          let dest = try KeyPair(accountId: self.recepientTextField.text ?? "")
          let issuer = try KeyPair(accountId: "GAOZD37RKO2OI3OIACY7T3UH4ZNEPR7T4ZFYT7IMTWDBLSQFKI4SCMNQ")
          
          guard let asset = Asset(type: AssetType.ASSET_TYPE_CREDIT_ALPHANUM12, code: "DISCOIN", issuer: issuer) else {
            return
          }
          
          let payment = PaymentOperation(sourceAccount: keyPair,
                                         destination: dest,
                                         asset: asset,
                                         amount: Decimal(Int(self.amountTextField.text ?? "0") ?? 0))
          
          let transaction = try Transaction(sourceAccount: details,
                                            operations: [payment],
                                            memo: .text(self.messageTextField.text ?? ""),
                                            timeBounds:nil)
          
          try transaction.sign(keyPair: keyPair, network: Network.testnet)
          
          try stellar.transactions.submitTransaction(transaction: transaction) { (response) -> (Void) in
            switch response {
            case .success(_):
              DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
              }
            case .failure(let error):
              StellarSDKLog.printHorizonRequestErrorMessage(tag:"SRP Test", horizonRequestError:error)
            }
          }
          
        } catch {
          self.presentAlert(text: "\(error.localizedDescription)")
        }
      }
    }

  }
  
  // MARK: - Network Events
  
  private func loadDetails() {
    guard let keyPair = Account.shared.keyPair else {
      return
    }
    
    let stellar = StellarManager.shared.stellar
    stellar.accounts.getAccountDetails(accountId: keyPair.accountId) { [weak self] response in
      guard let `self` = self else { return }
      
      switch response {
      case .success(let details):
        DispatchQueue.main.async {
          self.displayBalance(details)
        }
        
      default:
        break
      }
    }
  }
  
  private func displayBalance(_ details: AccountResponse) {
    for balance in details.balances where balance.assetCode == "DISCOIN" {
      balanceLabel.text = "£\(Double(balance.balance) ?? -1)"
    }
  }
  
}

