//
//  SettingCell.swift
//  Lunar
//
//  Created by hbkim on 2023/02/10.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import TheodoreCore

struct SettingCellForm {
  var icon: UIImage
  var title: String
  var action: (() -> Void)?
}

final class SettingCell: BaseTableViewCell {
  private var containerView: UIView!
  private var coreView: UIStackView!
  private var iconView: UIImageView!
  private var titleLabel: UILabel!

  var setting: SettingCellForm? {
    didSet {
      iconView.image = setting?.icon
      titleLabel.text = setting?.title
    }
  }

  override func setupViews() {
    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear

    containerView = UIView().apply {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 12
      $0.layer.shadowColor = UIColor.grayEEE.cgColor
      $0.layer.shadowOpacity = 3.0
      $0.layer.shadowOffset = .zero
      $0.layer.shadowRadius = 6
      contentView.addSubview($0)
    }

    coreView = UIStackView().apply {
      $0.axis = .horizontal
      $0.alignment = .fill
      $0.distribution = .fill
      $0.spacing = 12
      containerView.addSubview($0)
    }

    iconView = UIImageView().apply {
      $0.tintColor = .sc_icon
      coreView.addArrangedSubview($0)
    }

    titleLabel = UILabel().apply {
      $0.numberOfLines = 0
      $0.font = .preferredFont(.regular, size: 16)
      $0.textColor = .sc_title
      coreView.addArrangedSubview($0)
    }
  }

  override func setupConstraints() {
    containerView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.top.equalToSuperview().offset(8)
      $0.trailing.equalToSuperview().offset(-24)
      $0.bottom.equalToSuperview().offset(-8)
    }
    coreView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-16)
      $0.trailing.equalToSuperview().offset(-20)
    }
    iconView.snp.makeConstraints {
      $0.height.width.equalTo(24)
    }
  }
}
