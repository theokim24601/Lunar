//
//  UIView+Additions.swift
//  Lunar
//
//  Created by hbkim on 2023/11/16.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

extension UIView {
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return self.layer.cornerRadius
    }
    set {
      self.layer.cornerRadius = newValue
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
      return self.layer.borderWidth
    }
    set {
      self.layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
      return self.borderColor
    }
    set {
      self.layer.borderColor = newValue?.cgColor
    }
  }
}

extension UIView {
  func shadow(
    color: UIColor? = .black,
    opacity: Float = 0.5,
    offSet: CGSize = .zero,
    radius: CGFloat = 1,
    cornerRadius: CGFloat = 1,
    scale: Bool = true
  ) {
    layer.masksToBounds = false
    layer.shadowColor = color?.cgColor
    layer.shadowOpacity = opacity
    layer.shadowOffset = offSet
    layer.shadowRadius = radius
    layer.cornerRadius = cornerRadius

    layer.shadowPath = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: cornerRadius
    ).cgPath
    layer.shouldRasterize = true
    layer.rasterizationScale = scale ? UIScreen.main.scale : 1
  }
}
