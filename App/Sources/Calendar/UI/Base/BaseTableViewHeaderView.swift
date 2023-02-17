//
//  BaseTableViewHeaderView.swift
//  Lunar
//
//  Created by hbkim on 2023/02/14.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

class BaseTableViewHeaderView: UITableViewHeaderFooterView {

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    setupViews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {}
  func setupConstraints() {}
}
