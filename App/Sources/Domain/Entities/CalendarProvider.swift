//
//  CalendarProvider.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

enum CalendarProviderType: String, CaseIterable {
  case apple
  case google
}

class CalendarProvider: NSObject {
  var providerType: CalendarProviderType?
  var sync: Bool?

  init(type: CalendarProviderType, sync: Bool = false) {
    self.providerType = type
    self.sync = sync
  }

  required init?(coder: NSCoder) {
    let providerTypeRaw = coder.decodeObject(forKey: "providerType") as! String
    self.providerType = CalendarProviderType(rawValue: providerTypeRaw)
    self.sync = coder.decodeObject(forKey: "sync") as? Bool
  }
}
