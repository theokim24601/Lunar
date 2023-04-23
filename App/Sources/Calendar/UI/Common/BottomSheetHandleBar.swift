//
//  BottomSheetHandleBar.swift
//  Lunar
//
//  Created by hbkim on 2023/02/15.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import TheodoreCore

class BottomSheetHandleBar: BaseView {
  private var imageView: UIImageView!

  override func setupViews() {
    imageView = UIImageView()
    imageView.image = "ic_bottom_dismiss".uiImage
    backgroundColor = .clear
    addSubview(imageView)
  }

  override func setupConstraints() {
    imageView.snp.makeConstraints {
      $0.top.bottom.centerX.equalToSuperview()
    }
  }
}
