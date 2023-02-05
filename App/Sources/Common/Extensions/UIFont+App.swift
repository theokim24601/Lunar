//
//  UIFont+App.swift
//  Lunar
//
//  Created by hbkim on 2023/01/29.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

public enum AppFont {
  public enum Weight: String {
    case light = "Light"
    case regular = "Regular"
    case medium = "Medium"
    case bold = "Bold"
  }

  static func fullName(weight: Weight) -> String {
    return "SpoqaHanSansNeo-" + weight.rawValue
  }
}

public extension UIFont {
  class func preferredFont(_ weight: AppFont.Weight, size: CGFloat) -> UIFont {
    return UIFont(name: AppFont.fullName(weight: weight), size: size)!
  }
}
