//
//  SettingRepository.swift
//  Lunar
//
//  Created by hbkim on 2023/11/23.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation
import KeychainAccess

final class SettingRepository: SettingRepositoryType {

  // MARK: Constants

  private struct Key {
    static let service = "com.theo.Lunar"
    static let settings = "settings"
  }

  private let keychain: Keychain
  private(set) var current: Settings?

  init() {
    keychain = Keychain(service: Key.service)
    current = loadSettings()
  }

  func updateSync(type: CalendarProviderType, sync: Bool) -> Bool {
    let newSettings = makeNewSettings(type: type, sync: sync)
    guard let settings = saveSettings(settings: newSettings) else {
//      log.error("Failed to update settings.")
      return false
    }
    self.current = settings
    return true
  }
}

private extension SettingRepository {

  func makeNewSettings(type: CalendarProviderType, sync: Bool) -> Settings {
    guard let newSettings = current?.copy() as? Settings else {
      fatalError("Failed to copy current Settings")
    }

    guard let providers = newSettings.providers else {
      fatalError("")
    }

    for provider in providers where provider.providerType == type {
      provider.sync = sync
    }

    return newSettings
  }

  func loadSettings() -> Settings? {
    guard
      let settingsData = try? keychain.getData(Key.settings),
      let settings = NSKeyedUnarchiver.unarchiveObject(with: settingsData) as? Settings
      else {
//        log.info("Keychain hasn't a settings. It will return default settings.")
        return saveSettings(settings: Settings.default)
    }
    return settings
  }

  func saveSettings(settings: Settings) -> Settings? {
    let settingsData: Data = NSKeyedArchiver.archivedData(withRootObject: settings)

    do {
      try keychain.set(settingsData, key: Key.settings)
      return settings
    } catch _ {
//      log.error("Failed to save the settings to the keychain with key - \(Key.settings)")
      return nil
    }
  }
}
