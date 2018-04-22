//
//  ViewController.swift
//  Decenture
//
//  Created by Nathan Dane on 21/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit
import SnapKit

class TransactionHistoryViewController: UIViewController {

  private lazy var tableView = UITableView(frame: .zero, style: .grouped)
  private lazy var balanceView = BalanceView()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  override func loadView() {
    super.loadView()
    initLayout()
    makeConstraints()
  }

  private func initLayout() {
    tableView.backgroundColor = UIColor.discoin.green

    tableView.contentInsetAdjustmentBehavior = .never
    tableView.separatorStyle = .none
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(TransactionTableViewCell.self,
                       forCellReuseIdentifier: TransactionTableViewCell.reuseIdentifier)
    
    view.addSubview(tableView)
  }

  private func makeConstraints() {
    tableView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}

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

extension TransactionHistoryViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return balanceView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 300
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
    return 300
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return 60
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 30
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseIdentifier) else {
      fatalError("You probably forgot to register this cell class.")
    }
    
    // Change background color of every other cell
    if indexPath.row % 2 == 0 {
      cell.backgroundColor = UIColor.discoin.lightGrey
    } else {
      cell.backgroundColor = .white
    }

    return cell
  }

}
