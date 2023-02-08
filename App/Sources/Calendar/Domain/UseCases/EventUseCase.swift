//
//  EventUseCase.swift
//  Lunar
//
//  Created by hbkim on 2023/11/23.
//  Copyright © 2023 theo. All rights reserved.
//

final class EventUseCase {
  private let calendarRepository: CalendarRepository
  private let settingRepository: SettingRepository

  init(
    calendarRepository: CalendarRepository,
    settingRepository: SettingRepository
  ) {
    self.calendarRepository = calendarRepository
    self.settingRepository = settingRepository
  }

  func getAll() -> [Event] {
    return calendarRepository.events()
      .sorted(by: <)
  }

  func newEvent(_ event: Event) async -> Result<Event, Error> {
    let settings = settingRepository.current
    do {
      let event = try await calendarRepository.newEvent(event: event, providers: settings.onProviders)
      return .success(event)
    } catch (let error) {
      return .failure(error)
    }
  }

  func update(_ event: Event) async -> Result<Event, Error> {
    let settings = settingRepository.current
    do {
      let event = try await calendarRepository.updateEvent(event: event, providers: settings.onProviders)
      return .success(event)
    } catch (let error) {
      print("Failed to update the event with error - \(error.localizedDescription)")
      return .failure(error)
    }
  }

  func delete(_ id: String) async {
    let settings = settingRepository.current
    do {
      try await calendarRepository.deleteEvent(id, providers: settings.onProviders)
    } catch (let error) {
      print("Failed to delete the event with error - \(error.localizedDescription)")
    }
  }
}
