//
//  BalanceView.swift
//  Decenture
//
//  Created by Nathan Dane on 22/04/2018.
//  Copyright © 2018 Blockchainers. All rights reserved.
//

import UIKit
import SnapKit

protocol BalanceViewDelegate: class {
  func balanceViewDidTapSend(_ balanceView: BalanceView)
  func balanceViewDidTapRecieve(_ balanceView: BalanceView)
}

class BalanceView: UIView {
  
  // MARK: - UI Components
  
  private var iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = #imageLiteral(resourceName: "logo")
    imageView.contentMode = .scaleAspectFill
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
    label.textAlignment = .left
    label.text = "0.00"
    return label
  }()
  
  private let balanceContainer = UIView()
  
  private var buttonContainer = UIView()
  
  private var recieveButton: UIButton = {
    let button = UIButton()
    button.setTitle("+", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 64, weight: .ultraLight)
    button.addTarget(self, action: #selector(recieveButtonPressed), for: .touchUpInside)
    return button
  }()

  private var sendButton: UIButton = {
    let button = UIButton()
    button.setTitle("-", for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 64, weight: .ultraLight)
    button.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Public Members
  
  weak var delegate: BalanceViewDelegate?
  
  var balance: Double = 0 {
    didSet {
      balanceLabel.text = "\(balance)"
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
    
    [titleLabel,
     balanceContainer,
     buttonContainer].forEach(addSubview(_:))
    
    [balanceLabel, iconImageView].forEach(balanceContainer.addSubview(_:))
    [recieveButton, sendButton].forEach(buttonContainer.addSubview(_:))
  }
  
  private func makeConstraints() {
    iconImageView.snp.makeConstraints { make in
      make.width.height.equalTo(50)
      make.leading.top.bottom.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(35)
      make.leading.trailing.equalToSuperview()
    }
    
    balanceContainer.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(10)
    }

    balanceLabel.snp.makeConstraints { make in
      make.trailing.top.bottom.equalToSuperview()
      make.leading.equalTo(iconImageView.snp.trailing).offset(10)
    }
    
    buttonContainer.snp.makeConstraints { make in
      make.top.equalTo(balanceContainer.snp.bottom).offset(35)
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(45)
    }
    
    recieveButton.snp.makeConstraints { make in
      make.top.leading.bottom.equalToSuperview()
      make.width.height.equalTo(56)
    }
    
    sendButton.snp.makeConstraints { make in
      make.top.trailing.bottom.equalToSuperview()
      make.width.height.equalTo(recieveButton)
      make.leading.equalTo(recieveButton.snp.trailing).offset(15)
    }
  }
  
  // MARK: - Actions
  
  @objc private func sendButtonPressed() {
    delegate?.balanceViewDidTapSend(self)
  }
  
  @objc private func recieveButtonPressed() {
    delegate?.balanceViewDidTapRecieve(self)
  }

}
