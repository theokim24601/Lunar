//
//  SettingCell.swift
//  Lunar
//
//  Created by hbkim on 2023/02/10.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

struct SettingCellForm {
  var icon: UIImage
  var title: String
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

    containerView = UIView()
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 16
    containerView.layer.shadowColor = UIColor.grayEEE.cgColor
    containerView.layer.shadowOpacity = 3.0
    containerView.layer.shadowOffset = .zero
    containerView.layer.shadowRadius = 6
    contentView.addSubview(containerView)

    coreView = UIStackView()
    coreView.axis = .horizontal
    coreView.alignment = .fill
    coreView.distribution = .fill
    coreView.spacing = 12
    containerView.addSubview(coreView)

    iconView = UIImageView()
    iconView.tintColor = .sc_icon
    coreView.addArrangedSubview(iconView)

    titleLabel = UILabel()
    titleLabel.numberOfLines = 0
    titleLabel.font = .preferredFont(.regular, size: 16)
    titleLabel.textColor = .sc_title
    coreView.addArrangedSubview(titleLabel)
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
