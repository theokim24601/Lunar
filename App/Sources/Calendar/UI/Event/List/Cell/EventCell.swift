//
//  EventCell.swift
//  Lunar
//
//  Created by hbkim on 2023/10/26.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

final class EventCell: BaseTableViewCell {
  private var containerView: UIView!
  private var coreView: UIStackView!
  private var titleLabel: UILabel!
  private var lunarLabel: UILabel!
  private var gregorianLabel: UILabel!

  var event: Event? {
    didSet {
      guard
        let event,
        let title = event.title,
        let month = event.lunarMonth,
        let day = event.lunarDay
      else { return }
      titleLabel.text = title
      lunarLabel.text = "음력 ".appending("\(month)월 \(day)일")
      gregorianLabel.text = event
        .toNearestFutureIncludingToday()?
        .stringForSolar()
    }
  }

  override func setupViews() {
    selectionStyle = .none
    backgroundColor = .clear
    contentView.backgroundColor = .clear

    containerView = UIView()
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 28
    containerView.layer.shadowColor = UIColor.grayEEE.cgColor
    containerView.layer.shadowOpacity = 3.0
    containerView.layer.shadowOffset = .zero
    containerView.layer.shadowRadius = 6
    contentView.addSubview(containerView)

    coreView = UIStackView()
    coreView.axis = .vertical
    coreView.alignment = .fill
    coreView.distribution = .fill
    coreView.spacing = 4
    containerView.addSubview(coreView)

    titleLabel = UILabel()
    titleLabel.numberOfLines = 0
    titleLabel.font = .preferredFont(.medium, size: 16)
    titleLabel.textColor = .ec_title
    coreView.addArrangedSubview(titleLabel)

    lunarLabel = UILabel()
    lunarLabel.numberOfLines = 1
    lunarLabel.font = .preferredFont(.light, size: 12)
    lunarLabel.textColor = .ec_lunarLabel
    coreView.addArrangedSubview(lunarLabel)

    gregorianLabel = UILabel()
    gregorianLabel.numberOfLines = 1
    gregorianLabel.font = .preferredFont(.regular, size: 14)
    gregorianLabel.textColor = .ec_gregorianLabel
    containerView.addSubview(gregorianLabel)
  }

  override func setupConstraints() {
    let verticalMargin: CGFloat = 8
    let verticalPadding: CGFloat = 16
    containerView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24)
      $0.top.equalToSuperview().offset(verticalMargin)
      $0.trailing.equalToSuperview().offset(-24)
      $0.bottom.equalToSuperview().offset(-verticalMargin)
    }
    coreView.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(verticalPadding)
      $0.bottom.equalToSuperview().offset(-verticalPadding)
      $0.trailing.equalTo(gregorianLabel.snp.leading).offset(-verticalPadding)
    }
    titleLabel.snp.makeConstraints {
      $0.height.equalTo(24)
    }
    lunarLabel.snp.makeConstraints {
      $0.height.equalTo(20)
    }
    gregorianLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(verticalPadding)
      $0.trailing.equalToSuperview().offset(-verticalPadding)
    }
    gregorianLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
  }
}
