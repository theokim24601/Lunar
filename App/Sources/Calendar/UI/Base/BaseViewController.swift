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

  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    Task {
      await MainActor.run {
        navigationController?.navigationBar.sizeToFit()
      }
    }
  }

  open func setupViews() {}
  open func setupConstraints() {}

  func setupNavigationBar(title: String? = nil) {
    view.backgroundColor = .el_background
    navigationItem.title = title
    navigationController?.view.backgroundColor = .clear
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.largeTitleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.el_navi_title,
      NSAttributedString.Key.font: UIFont.preferredFont(.medium, size: 34)
    ]

    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.el_navi_title,
      NSAttributedString.Key.font: UIFont.preferredFont(.regular, size: 16)
    ]
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.tintColor = .el_navi_title
  }
}
