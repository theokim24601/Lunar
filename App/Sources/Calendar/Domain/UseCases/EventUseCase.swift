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
    let providers = await syncUpProviderStatus()
    do {
      let event = try calendarRepository.newEvent(event: event, providers: providers)
      return .success(event)
    } catch (let error) {
      return .failure(error)
    }
  }

  func update(_ event: Event) async -> Result<Event, Error> {
    let providers = await syncUpProviderStatus()
    do {
      let event = try calendarRepository.updateEvent(event: event, providers: providers)
      return .success(event)
    } catch (let error) {
      print("Failed to update the event with error - \(error.localizedDescription)")
      return .failure(error)
    }
  }

  func delete(_ id: String) async {
    let providers = await syncUpProviderStatus()
    do {
      try calendarRepository.deleteEvent(id, providers: providers)
    } catch (let error) {
      print("Failed to delete the event with error - \(error.localizedDescription)")
    }
  }
}

private extension EventUseCase {
  func syncUpProviderStatus() async -> [CalendarProvider] {
    var providers: [CalendarProvider] = []
    for provider in settingRepository.current.onProviders {
      let accessGranted = await calendarRepository.verifyAuthorizationStatus(provider: provider)
      if accessGranted {
        providers.append(provider)
      } else {
        let newProviderSetting = CalendarProviderSetting(provider: provider, sync: false)
        _ = settingRepository.updateProviderSetting(setting: newProviderSetting)
      }
    }
    return providers
  }
}
