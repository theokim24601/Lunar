//
//  Settings.swift
//  Lunar
//
//  Created by hbkim on 2023/11/27.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

class Settings: NSObject, NSCoding {
  var providerSettings: [CalendarProviderSetting] = []

  init(providerSettings: [CalendarProviderSetting]) {
    self.providerSettings = providerSettings
  }

  required init?(coder: NSCoder) {
    guard
      let providerSettings = coder.decodeObject(forKey: "providerSettings") as? [CalendarProviderSetting]
    else { return nil }
    self.providerSettings = providerSettings
  }

  func encode(with coder: NSCoder) {
    coder.encode(providerSettings, forKey: "providerSettings")
  }

  static let `default`: Settings = {
    var providerSettings: [CalendarProviderSetting] = []
    for provider in CalendarProvider.allCases {
      providerSettings.append(CalendarProviderSetting(provider: provider))
    }
    return Settings(providerSettings: providerSettings)
  }()
}

extension Settings {
  var onProviders: [CalendarProvider] {
    var providers: [CalendarProvider] = []
    for setting in providerSettings where setting.sync {
      providers.append(setting.provider)
    }
    return providers
  }
}
