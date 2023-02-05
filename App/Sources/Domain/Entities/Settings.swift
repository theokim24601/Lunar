//
//  Settings.swift
//  Lunar
//
//  Created by hbkim on 2023/11/27.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

class Settings: NSObject {

  var providers: [CalendarProvider]?

  init(providers: [CalendarProvider]) {
    self.providers = providers
  }

  required init?(coder: NSCoder) {
    guard let providers = coder.decodeObject(forKey: "providers") as? [CalendarProvider] else {
      return nil
    }
    self.providers = providers
  }
}
