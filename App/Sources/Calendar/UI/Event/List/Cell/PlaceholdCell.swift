//
//  PlaceholdCell.swift
//  Lunar
//
//  Created by hbkim on 2023/02/15.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import TheodoreCore

final class PlaceholdCell: BaseTableViewCell {
  private var containerView: UIView!
  private var titleLabel: UILabel!

  override func setupViews() {
    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear

    containerView = UIView().apply {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 16
      $0.layer.shadowColor = UIColor.grayEEE.cgColor
      $0.layer.shadowOpacity = 3.0
      $0.layer.shadowOffset = .zero
      $0.layer.shadowRadius = 6
      contentView.addSubview($0)
    }

    titleLabel = UILabel().apply {
      $0.numberOfLines = 0
      $0.font = .preferredFont(.medium, size: 16)
      $0.textColor = .ph_title
      $0.text = "새로운 일정을 추가하세요"
      $0.textAlignment = .center
      containerView.addSubview($0)
    }
  }

  override func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.top.equalToSuperview().offset(8)
      $0.trailing.equalToSuperview().offset(-24)
      $0.bottom.equalToSuperview().offset(-8)
    }
    titleLabel.snp.makeConstraints {
      $0.height.equalTo(24)
      $0.edges.equalToSuperview().inset(16)
    }
  }
}
