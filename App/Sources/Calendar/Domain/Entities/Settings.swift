//
//  Settings.swift
//  Lunar
//
//  Created by hbkim on 2023/11/27.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

class Settings: NSObject, NSSecureCoding, NSCopying {
  static var supportsSecureCoding: Bool = false

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

  func supportNewProvider() {
    for provider in CalendarProvider.allCases {
      if !providerSettings.contains(where: { $0.provider == provider }) {
        providerSettings.append(CalendarProviderSetting(provider: provider))
      }
    }
  }

  static let `default`: Settings = {
    var providerSettings: [CalendarProviderSetting] = []
    for provider in CalendarProvider.allCases {
      providerSettings.append(CalendarProviderSetting(provider: provider))
    }
    return Settings(providerSettings: providerSettings)
  }()

  func copy(with zone: NSZone? = nil) -> Any {
    return Settings(
      providerSettings: providerSettings.map { $0.copy() as! CalendarProviderSetting }
    )
  }
}

extension Settings {
  var onProviders: [CalendarProvider] {
    var providers: [CalendarProvider] = []
    for setting in providerSettings where setting.sync {
      providers.append(setting.provider)
    }
    return providers
  }

  var hasProvider: Bool {
    return !onProviders.isEmpty
  }
}
