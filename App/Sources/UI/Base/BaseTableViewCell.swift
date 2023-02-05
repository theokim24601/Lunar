//
//  BaseTableViewCell.swift
//  Lunar
//
//  Created by hbkim on 2023/01/30.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {}
  func setupConstraints() {}
}
