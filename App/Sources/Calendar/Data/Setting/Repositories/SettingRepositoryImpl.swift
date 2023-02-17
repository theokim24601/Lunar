//
//  SettingRepositoryImpl.swift
//  Lunar
//
//  Created by hbkim on 2023/11/23.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation
import KeychainAccess

final class SettingRepositoryImpl: SettingRepository {
  private struct Key {
    static let service = "kim.theo.lunar"
    static let settings = "settings"
  }

  private let keychain: Keychain
  private(set) lazy var current: Settings = loadSettings()

  init() {
    keychain = Keychain(service: Key.service)
  }

  func updateProviderSetting(setting: CalendarProviderSetting) -> Bool {
    guard let newSettings = current.copy() as? Settings else {
      fatalError("Failed to copy current Settings")
    }

    let providerSettings = newSettings.providerSettings
    for providerSetting in providerSettings where providerSetting.provider == setting.provider {
      providerSetting.sync = setting.sync
    }

    guard let settings = saveSettings(settings: newSettings) else {
      return false
    }
    self.current = settings
    return true
  }
}

private extension SettingRepositoryImpl {
  func loadSettings() -> Settings {
    guard
      let settingsData = try? keychain.getData(Key.settings),
      let settings = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(settingsData) as? Settings
    else {
      return saveSettings(settings: Settings.default) ?? Settings.default
    }
    settings.supportNewProvider()
    return settings
  }

  func saveSettings(settings: Settings) -> Settings? {
    do {
      let settingsData: Data = try NSKeyedArchiver.archivedData(withRootObject: settings, requiringSecureCoding: false)
      try keychain.set(settingsData, key: Key.settings)
      return settings
    } catch {
      return nil
    }
  }
}
