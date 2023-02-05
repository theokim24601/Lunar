//
//  UIViewContoller+Additions.swift
//  Lunar
//
//  Created by hbkim on 2023/11/02.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

extension UIViewController {
  private class func instantiateControllerInStoryboard<T: UIViewController>(
    _ storyboard: UIStoryboard,
    identifier: String
    ) -> T {
    return storyboard.instantiateViewController(withIdentifier: identifier) as! T
  }

  class func controllerInStoryboard(
    _ storyboard: UIStoryboard,
    identifier: String
    ) -> Self {
    return instantiateControllerInStoryboard(storyboard, identifier: identifier)
  }

  class func controllerFromStoryboard(_ identifier: String) -> Self {
    return controllerInStoryboard(UIStoryboard(name: identifier, bundle: nil), identifier: nameOfClass)
  }
}

extension NSObject {
  class var nameOfClass: String {
    return NSStringFromClass(self).components(separatedBy: ".").last!
  }
}
