//
//  SettingHeaderView.swift
//  Lunar
//
//  Created by hbkim on 2023/02/14.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

class SettingHeaderView: BaseTableViewHeaderView {
  var titleLabel: UILabel!

  override func setupViews() {
    titleLabel = UILabel().apply {
      $0.textColor = .t1l_t3
      $0.font = .preferredFont(.regular, size: 12)
      contentView.addSubview($0)
    }
  }

  override func setupConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.top.equalToSuperview().offset(16)
      $0.bottom.equalToSuperview().offset(-4)
    }
  }
}
