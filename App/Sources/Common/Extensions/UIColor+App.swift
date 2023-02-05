//
//  UIColor+App.swift
//  Lunar
//
//  Created by hbkim on 2023/01/29.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import SwiftUI

// MARK: - Event List
public extension UIColor {
}

// MARK: - Event Edit
public extension UIColor {
  static var dimmedBackground: UIColor = .init(
    light: .init(r: 158, g: 48, b: 254, a: 1),
    dark: .init(r: 158, g: 48, b: 254, a: 1)
  )
}

public extension UIColor {
  static let t1lPrimaryFill1 = UIColor(hex: 0x3E32FF)
  static let t1lPrimaryFill2 = UIColor(hex: 0xEEF2FA)

  static let t1lPrimaryText1 = UIColor(hex: 0x141240)
  static let t1lPrimaryText2 = UIColor(hex: 0xEEF2FA)
  static let t1lPrimaryText3 = UIColor(hex: 0x99A0BD)

  static let t1lSecondaryColor1 = UIColor(hex: 0xE0DFED)
  static let t1lSecondaryColor2 = UIColor(hex: 0x706E82)

  static let warnColor1 = UIColor(hex: 0xFF3232)
}

public extension UIColor {
  convenience init(r: Int, g: Int, b: Int, a: Float) {
    assert(r >= 0 && r <= 255, "Invalid red component")
    assert(g >= 0 && g <= 255, "Invalid green component")
    assert(b >= 0 && b <= 255, "Invalid blue component")

    self.init(
      red: CGFloat(r) / 255.0,
      green: CGFloat(g) / 255.0,
      blue: CGFloat(b) / 255.0,
      alpha: CGFloat(a)
    )
  }

  convenience init(hex: Int, alpha: Float = 1.0) {
    self.init(
      r: (hex >> 16) & 0xff,
      g: (hex >> 8) & 0xff,
      b: hex & 0xff,
      a: alpha
    )
  }

  convenience init(light: UIColor, dark: UIColor) {
    self.init { traitCollection in
      if traitCollection.userInterfaceStyle == .dark {
        return dark
      } else {
        return light
      }
    }
  }
}
