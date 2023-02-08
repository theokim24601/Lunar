//
//  BaseView.swift
//  Lunar
//
//  Created by hbkim on 2023/02/04.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

class BaseView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupViews() {}
  func setupConstraints() {}
}
