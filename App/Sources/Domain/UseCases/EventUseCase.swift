//
//  EventUseCase.swift
//  Lunar
//
//  Created by hbkim on 2023/11/23.
//  Copyright © 2023 theo. All rights reserved.
//

class EventUseCase: UseCase {

  let calendarRepository: CalendarRepositoryType
  let settingRepository: SettingRepositoryType

  init(
    calendarRepository: CalendarRepositoryType,
    settingRepository: SettingRepositoryType
  ) {
    self.calendarRepository = calendarRepository
    self.settingRepository = settingRepository
  }

  func getAll() -> [Event] {
    return calendarRepository.events(types: synchronizedProviders())
  }

  func new(_ event: Event) {
    calendarRepository.newEvent(event: event, types: synchronizedProviders()) { result in
      switch result {
      case .success:
        break
      case .failure(let error):
        break
      }
    }
  }

  func update(_ event: Event) {
    calendarRepository.updateEvent(event: event, types: synchronizedProviders()) { result in
      switch result {
      case .success:
        break
      case .failure(let error):
        break
//        log.error("Failed to update the event with error - \(error.localizedDescription)")
      }
    }
  }

  func delete(_ id: String) {
    calendarRepository.deleteEvent(id: id, types: synchronizedProviders()) { result in
      switch result {
      case .success:
        break
//        log.info("Successfully deleted the event!")
      case .failure(let error):
        break
//        log.error("Failed to delete the event with error - \(error.localizedDescription)")
      }
    }
  }
}

private extension EventUseCase {
  func synchronizedProviders() -> [CalendarProviderType] {
    return (settingRepository.current?.providers ?? [])
      .filter { $0.sync == true }
      .map { $0.providerType! }
  }
}
