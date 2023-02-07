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

  private var imageView: UIImageView!
  private var logoLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    animateSplash()
  }

  override func setupViews() {
    view.backgroundColor = .sp_background

    imageView = UIImageView().apply {
      $0.image = "bg_splash".uiImage
      view.addSubview($0)
    }

    logoLabel = UILabel().apply {
      $0.text = "음력을\n알려줘"
      $0.numberOfLines = 0
      $0.alpha = 0
      $0.textColor = .t1l_t1
      $0.font = .preferredFont(.medium, size: 28)
      view.addSubview($0)
    }
  }

  override func setupConstraints() {
    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    logoLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(90)
      $0.bottom.equalToSuperview().offset(-120)
    }
  }

  func animateSplash() {
    imageView.transform = CGAffineTransform(translationX: 0, y: 20)
    imageView.alpha = 0

    UIView.animate(withDuration: 1, delay: 0.25, options: .curveEaseOut, animations: {
      self.imageView.transform = CGAffineTransform.identity
      self.imageView.alpha = 1
    })

    logoLabel.transform = CGAffineTransform(translationX: 0, y: 20)
    logoLabel.alpha = 0

    UIView.animate(withDuration: 1.25, delay: 1, options: .curveEaseOut, animations: {
      self.logoLabel.transform = CGAffineTransform.identity
      self.logoLabel.alpha = 1
    }, completion: { _ in
      self.finishFlow?()
    })
  }
}
