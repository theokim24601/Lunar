//
//  CalendarProviderSetting.swift
//  Lunar
//
//  Created by hbkim on 2023/02/08.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

class CalendarProviderSetting: NSObject, NSCoding, NSCopying {
  var provider: CalendarProvider
  var sync: Bool

  init(provider: CalendarProvider, sync: Bool = false) {
    self.provider = provider
    self.sync = sync
  }

  required init?(coder: NSCoder) {
    let providerTypeRaw = coder.decodeObject(forKey: "providerString") as! String
    guard let provider = CalendarProvider(rawValue: providerTypeRaw) else {
      return nil
    }
    self.provider = provider
    self.sync = coder.decodeBool(forKey: "sync")
  }

  func encode(with coder: NSCoder) {
    coder.encode(provider.rawValue, forKey: "providerString")
    coder.encode(sync, forKey: "sync")
  }

  func copy(with zone: NSZone? = nil) -> Any {
    return CalendarProviderSetting(
      provider: provider,
      sync: sync
    )
  }
}
