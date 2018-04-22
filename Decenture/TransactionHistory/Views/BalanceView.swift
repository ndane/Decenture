//
//  BalanceView.swift
//  Decenture
//
//  Created by Nathan Dane on 22/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit
import SnapKit

class BalanceView: UIView {
  
  // MARK: - UI Components
  
  private var iconImageView: UIImageView = {
    let imageView = UIImageView()
    return imageView
  }()
  
  private var titleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 32, weight: .light)
    label.textColor = .white
    label.textAlignment = .center
    label.text = "Your Balance"
    return label
  }()

  private var balanceLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 64, weight: .light)
    label.textColor = .white
    label.textAlignment = .center
    label.text = "£0.00"
    return label
  }()
  
  // MARK: - Public Members
  
  var balance: Double = 0 {
    didSet {
      balanceLabel.text = "£\(balance)"
    }
  }

  // MARK: - Lifecycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initLayout()
    makeConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func initLayout() {
    backgroundColor = UIColor.discoin.green
    
    [iconImageView,
     titleLabel,
     balanceLabel].forEach(addSubview(_:))
  }
  
  private func makeConstraints() {
    titleLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(45)
    }
    
    balanceLabel.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(25)
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
      make.bottom.equalToSuperview().inset(100)
    }
  }

}
