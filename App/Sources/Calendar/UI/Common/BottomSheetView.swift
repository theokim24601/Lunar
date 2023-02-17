//
//  BottomSheetView.swift
//  Lunar
//
//  Created by hbkim on 2023/02/15.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

class BottomSheetView: BaseViewController {
  private let maxDimmedAlpha: CGFloat = 0.6
  private var dimmedView: UIView!

  private let containerDefaultHeight: CGFloat = 240
  var containerView: UIView!

  convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    modalPresentationStyle = .overFullScreen
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyboardNotifications()
  }

  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  private func unregisterForKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }


  override func setupViews() {
    dimmedView = UIView()
    dimmedView.backgroundColor = .black
    dimmedView.alpha = maxDimmedAlpha
    dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedWasTapped)))
    view.addSubview(dimmedView)

    containerView = UIView()
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 16
    containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.addSubview(containerView)
  }

  override func setupConstraints() {
    dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    containerView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(containerDefaultHeight)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    animateShowDimmedView()
    animatePresentContainer()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForKeyboardNotifications()
  }

  @objc func keyboardWillShow(_ notification: NSNotification) {
    if let userInfo = notification.userInfo,
       let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
       let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
      UIView.animate(withDuration: duration, delay: 0, animations: {
        self.containerView.transform = CGAffineTransform(translationX: 0, y: -keyboardRect.height)
      })
    }
  }

  @objc func keyboardWillHide(_ notification: NSNotification) {
    containerView.transform = .identity
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }

  func animateShowDimmedView() {
    dimmedView.alpha = 0
    UIView.animate(withDuration: 0.4) {
      self.dimmedView.alpha = self.maxDimmedAlpha
    }
  }

  func animatePresentContainer() {
    containerView.snp.updateConstraints {
      $0.bottom.equalToSuperview()
    }
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }

  @objc func dimmedWasTapped() {
    animateDismissView()
  }

  func animateDismissView() {
    containerView.snp.updateConstraints {
      $0.bottom.equalToSuperview().offset(containerView.frame.height)
    }
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }

    dimmedView.alpha = maxDimmedAlpha
    UIView.animate(withDuration: 0.4) {
      self.dimmedView.alpha = 0
    } completion: { _ in
      self.dismiss(animated: false)
    }
  }
}
