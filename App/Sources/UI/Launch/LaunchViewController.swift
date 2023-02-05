//
//  LaunchViewController.swift
//  Lunar
//
//  Created by hbkim on 2020/02/08.
//  Copyright © 2020 theo. All rights reserved.
//

import UIKit
import SnapKit

final class LaunchViewController: BaseViewController {

  var finishFlow: (() -> Void)?

  private var logoLabel: UILabel!
  private var imageView: UIImageView!

  override func setupViews() {
    logoLabel = UILabel()
    logoLabel.text = "음력을\n알려줘"
    logoLabel.numberOfLines = 0
    logoLabel.font = .preferredFont(.regular, size: 24)
    view.addSubview(logoLabel)

    imageView = UIImageView()
    imageView.image = "ic_moon_light_off".uiImage
    view.addSubview(imageView)
  }

  override func setupConstraints() {
    logoLabel.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    imageView.snp.makeConstraints {
      $0.trailing.equalTo(logoLabel.snp.leading).offset(8)
      $0.bottom.equalTo(logoLabel.snp.top)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { [weak self] _ in
      self?.imageView.image = "ic_moon_light_on".uiImage
      Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
        self?.finishFlow?()
      }
    }
  }
}
