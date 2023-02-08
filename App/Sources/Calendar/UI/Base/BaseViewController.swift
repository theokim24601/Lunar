//
//  BaseViewController.swift
//  Lunar
//
//  Created by hbkim on 2023/11/18.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController {

  open override var preferredStatusBarStyle: UIStatusBarStyle {
    return .darkContent
  }

  open override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
  }

  open func setupViews() {}
  open func setupConstraints() {}
}
