//
//  SyncUseCase.swift
//  Lunar
//
//  Created by hbkim on 2023/11/23.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

class SyncUseCase: UseCase {

  let calendarRepository: CalendarRepositoryType
  let settingRepository: SettingRepositoryType

  init(
    calendarRepository: CalendarRepositoryType,
    settingRepository: SettingRepositoryType
  ) {
    self.calendarRepository = calendarRepository
    self.settingRepository = settingRepository
  }

  func currentSettings() -> Settings? {
    return settingRepository.current
  }

  func updateSync(
    type: CalendarProviderType,
    sync: Bool,
    completion: @escaping (Result<Bool, CalendarError>) -> Void
  ) {
    guard sync == true else {
      updateDataSource(type: type, sync: sync, completion: completion)
      return
    }
    calendarRepository.authorization(type: type) { result in
      switch result {
      case .success:
        DispatchQueue.main.async {
          self.updateDataSource(type: type, sync: sync, completion: completion)
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

private extension SyncUseCase {
  func updateDataSource(
    type: CalendarProviderType,
    sync: Bool,
    completion: @escaping CalendarServiceResponse
  ) {
    let result = settingRepository.updateSync(type: type, sync: sync)
    if result {
      if sync {
        calendarRepository.syncCalendar(type: type, completion: completion)
      } else {
        calendarRepository.unsyncCalendar(type: type, completion: completion)
      }
    } else {
      completion(.failure(.calendarSyncFailedInLocal))
    }
  }
}
