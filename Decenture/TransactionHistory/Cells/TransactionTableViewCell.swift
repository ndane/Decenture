//
//  TransactionTableViewCell.swift
//  Decenture
//
//  Created by Nathan Dane on 22/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit
import stellarsdk

class TransactionTableViewCell: UITableViewCell {
  
  // MARK: - Static Members

  static var reuseIdentifier: String {
    return String(describing: self)
  }

  // MARK: - UI Components
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.text = "Eduardo H."
    label.font = UIFont.systemFont(ofSize: 13)
    label.textColor = UIColor.discoin.greyBlue
    return label
  }()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.text = "MARCH 28, 2015 12:20pm"
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()

  private let priceLabel: UILabel = {
    let label = UILabel()
    label.text = "+ $200.00"
    label.font = UIFont.systemFont(ofSize: 20)
    label.textColor = UIColor.discoin.green
    return label
  }()
  
  // MARK: - Payments
  
  var payment: PaymentOperationResponse? {
    didSet {
      update()
    }
  }
  
  // MARK: - Lifecycle

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    initLayout()
    makeConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func initLayout() {
    selectionStyle = .none

    [nameLabel,
     dateLabel,
     priceLabel].forEach(addSubview(_:))
  }

  private func makeConstraints() {
    nameLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(17)
      make.leading.equalToSuperview().inset(25)
      make.width.lessThanOrEqualTo(200)
    }
    
    dateLabel.snp.makeConstraints { make in
      make.leading.equalTo(nameLabel.snp.leading)
      make.top.equalTo(nameLabel.snp.bottom)
      make.bottom.equalToSuperview().inset(17)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.trailing.equalToSuperview().inset(25)
      make.centerY.equalToSuperview()
    }
  }

  private func update() {
    guard let payment = payment else { return }

    if payment.to == Account.shared.keyPair?.accountId ?? "" {
      priceLabel.text = "+ £\(Double(payment.amount) ?? 0)"
      priceLabel.textColor = UIColor.discoin.green
      nameLabel.text = payment.from
    } else {
      priceLabel.text = "- £\(Double(payment.amount) ?? 0)"
      priceLabel.textColor = UIColor.discoin.red
      nameLabel.text = payment.to
    }
  }

}
