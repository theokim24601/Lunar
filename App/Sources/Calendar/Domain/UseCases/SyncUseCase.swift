//
//  SyncUseCase.swift
//  Lunar
//
//  Created by hbkim on 2023/11/23.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation
import EventKit

final class SyncUseCase {
  private let calendarRepository: CalendarRepository
  private let settingRepository: SettingRepository

  init(
    calendarRepository: CalendarRepository,
    settingRepository: SettingRepository
  ) {
    self.calendarRepository = calendarRepository
    self.settingRepository = settingRepository
  }

  func currentSettings() -> Settings {
    return settingRepository.current
  }

  func updateSyncStatus(provider: CalendarProvider, sync: Bool) async -> Result<Void, CalendarError> {
    let providerSettings = CalendarProviderSetting(provider: provider, sync: sync)
    let result = settingRepository.updateProviderSetting(setting: providerSettings)
    if result {
      let accessGranted = await calendarRepository.verifyAuthorizationStatus(provider: provider)
      if !accessGranted {
        return .failure(.calendarAccessDeniedOrRestricted)
      }
      do {
        if sync {
          try calendarRepository.syncCalendar(provider: provider)
        } else {
          try calendarRepository.unsyncCalendar(provider: provider)
        }
        return .success(())
      } catch {
        return .failure(.calendarSyncFailedInLocal)
      }
    } else {
      return .failure(.calendarSyncFailedInLocal)
    }
  }
}
