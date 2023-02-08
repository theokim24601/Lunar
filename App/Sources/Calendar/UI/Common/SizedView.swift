//
//  SizedView.swift
//  Lunar
//
//  Created by hbkim on 2023/02/04.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import SnapKit

final class SizedView: BaseView {

  var height: CGFloat?
  var width: CGFloat?

  init(height: CGFloat? = nil, width: CGFloat? = nil) {
    self.height = height
    self.width = width
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setupConstraints() {
    snp.makeConstraints {
      if let height {
        $0.height.equalTo(height)
      }
      if let width {
        $0.width.equalTo(width)
      }
    }
  }
}
