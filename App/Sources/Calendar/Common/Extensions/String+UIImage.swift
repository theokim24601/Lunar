//
//  String+UIImage.swift
//  Lunar
//
//  Created by hbkim on 2023/01/29.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

public extension String {
  var uiImage: UIImage? {
    return UIImage(named: self, in: Bundle.main, compatibleWith: .none)
  }
}

extension String {
  func leftPadding(toLength: Int, withPad character: Character) -> String {
    let stringLength = self.count
    if stringLength < toLength {
      return String(repeatElement(character, count: toLength - stringLength)) + self
    } else {
      return String(self.suffix(toLength))
    }
  }
}
