//
//  ViewController.swift
//  Decenture
//
//  Created by Nathan Dane on 21/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit
import SnapKit
import stellarsdk

class TransactionHistoryViewController: UIViewController {
  
  // MARK: - UI Components

  private lazy var tableView = UITableView(frame: .zero, style: .grouped)
  private lazy var balanceView = BalanceView()
  
  // MARK: - Override Members
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // MARK: - Private Members
  
  private var payments: [PaymentOperationResponse] = []
  
  // MARK: - Lifecycle

  override func loadView() {
    super.loadView()
    initLayout()
    makeConstraints()
  }

  private func initLayout() {
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TransactionTableViewCell.self,
                       forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
    
    balanceView.delegate = self
    
    view.addSubview(tableView)
  }

  private func makeConstraints() {
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    loadDetails()
    loadPayments()
  }
    
  // MARK: - Networking
  
  private func loadDetails() {
    guard let keyPair = Account.shared.keyPair else {
      presentAlert(text: "Couldn't find your account ID")
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
        
      case .failure(let error):
        self.presentAlert(text: error.localizedDescription)
      }
    }
  }
  
  private func loadPayments() {
    guard let keyPair = Account.shared.keyPair else {
      presentAlert(text: "Couldn't find your account ID")
      return
    }
    
    let stellar = StellarManager.shared.stellar
    stellar.payments.getPayments(forAccount: keyPair.accountId) { response in
      switch response {
      case .success(let details):
        DispatchQueue.main.async {
          self.displayPayments(details.records)
          self.startPaymentsStream()
        }
        
      case .failure(let error):
        self.presentAlert(text: error.localizedDescription)
      }
    }
  }
  
  private func startPaymentsStream() {
    guard let keyPair = Account.shared.keyPair else {
      presentAlert(text: "Couldn't find your account ID")
      return
    }
    
    let stellar = StellarManager.shared.stellar
    stellar.payments.stream(for: .paymentsForAccount(account: keyPair.accountId, cursor: nil)).onReceive { [weak self] response in
      guard let `self` = self else { return }

      switch response {
      case .open:
        break
        
      case .response(_, let operationResponse):
        guard let payment = operationResponse as? PaymentOperationResponse else { return }
        if payment.assetCode == "DISCOIN", self.payments.contains(payment) == false {
          self.payments.insert(payment, at: 0)
          DispatchQueue.main.async {
            self.tableView.reloadData()
            self.loadDetails()
          }
        }

      case .error:
        break
      }
    }
  }
  
  private func displayBalance(_ details: AccountResponse) {
    for balance in details.balances where balance.assetCode == "DISCOIN" {
      balanceView.balance = Double(balance.balance) ?? -1
    }
  }
  
  private func displayPayments(_ details: [OperationResponse]) {
    var payments: [PaymentOperationResponse] = []

    for record in details {
      guard let record = record as? PaymentOperationResponse else { continue }
      if record.assetCode == "DISCOIN" {
        payments.append(record)
      }
    }
    
    self.payments = payments.reversed()
    tableView.reloadData()
    
    if payments.count > 0 {
      tableView.backgroundColor = UIColor.discoin.green
    } else {
      tableView.backgroundColor = .white
    }
  }
  
}

// MARK: - UITableViewDelegate
extension TransactionHistoryViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    // Just some simple color changes
    if indexPath.row == self.tableView(tableView, numberOfRowsInSection: 0) - 1 {
      tableView.backgroundColor = .white
    }
    
    if indexPath.row == 0 {
      tableView.backgroundColor = UIColor.discoin.green
    }
  }
}

// MARK: - UITableViewDataSource
extension TransactionHistoryViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return balanceView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 350
  }

  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    return 350
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return payments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier)
      as? TransactionTableViewCell else {
      fatalError("You probably forgot to register this cell class.")
    }
    
    // Change background color of every other cell
    if indexPath.row % 2 == 0 {
      cell.backgroundColor = UIColor.discoin.lightGrey
    } else {
      cell.backgroundColor = .white
    }
    
    guard indexPath.row < payments.count else { return cell }
    cell.payment = payments[indexPath.row]

    return cell
  }

}

// MARK: - BalanceViewDelegate
extension TransactionHistoryViewController: BalanceViewDelegate {

  func balanceViewDidTapSend(_ balanceView: BalanceView) {
    present(SendFundsViewController(), animated: true)
  }
  
  func balanceViewDidTapRecieve(_ balanceView: BalanceView) {
    present(RecieveFundsViewController(), animated: true)
  }

}
