//
//  CalendarRepository.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

final class CalendarRepository: CalendarRepositoryType {

  private let local: CalendarLocalDataSourceType
  private let remote: CalendarRemoteDataSourceType

  init(local: CalendarLocalDataSourceType, remote: CalendarRemoteDataSourceType) {
    self.local = local
    self.remote = remote
  }

  func events(types: [CalendarProviderType]) -> [Event] {
    let events = local.selectEvents()
      .map(Event.init)
      .sorted(by: <)

    let needToUpdateEvents = events
      .map(Event.init)
      .map { $0.convertForRemote() }
    
    types.forEach { type in
      remote.insertEvents(events: needToUpdateEvents, type: type) { _ in }
    }

    return events
  }

  func event(id: String) -> Event? {
    if let dbEvent = local.selectEvent(id: id) {
      return Event(event: dbEvent)
    }
    return nil
  }

  func newEvent(
    event: Event,
    types: [CalendarProviderType],
    completion: (Result<Event, CalendarError>) -> Void
  ) {
    local.insertEvent(event: event.convertForRealm()) { result in
      switch result {
      case .success(let dbEvent):
        let newEvent = Event(event: dbEvent).convertForRemote()
        remote.insertEvent(event: newEvent, types: types)
        completion(.success(newEvent))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func updateEvent(
    event: Event,
    types: [CalendarProviderType],
    completion: (Result<Event, CalendarError>) -> Void
  ) {
    guard let id = event.id,
      let oldDBEvent = local.selectEvent(id: id) else {
        completion(.failure(.eventNotExistsInCalendar))
        return
    }
    let oldEvent = Event(event: oldDBEvent).convertForRemote()
    local.updateEvent(event: event.convertForRealm()) { result in
      switch result {
      case .success(let newDBEvent):
        let newEvent = Event(event: newDBEvent).convertForRemote()
        remote.updateEvent(oldEvent: oldEvent, newEvent: newEvent, types: types)

        completion(.success(newEvent))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func deleteEvent(
    id: String,
    types: [CalendarProviderType],
    completion: CalendarServiceResponse
  ) {
    guard let dbEvent = local.selectEvent(id: id) else {
      completion(.failure(.eventNotExistsInCalendar))
      return
    }
    let eventForRemove = Event(event: dbEvent).convertForRemote()
    local.deleteEvent(id: id) { result in
      switch result {
      case .success:
        remote.deleteEvent(event: eventForRemove, types: types)
        completion(.success(true))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func authorization(type: CalendarProviderType, completion: @escaping CalendarServiceResponse) {
    remote.authorization(type: type, completion: completion)
  }

  func syncCalendar(type: CalendarProviderType, completion: @escaping CalendarServiceResponse) {
    let events = local.selectEvents()
      .map(Event.init)
      .map { $0.convertForRemote() }
    remote.insertEvents(events: events, type: type, completion: completion)
  }

  func unsyncCalendar(type: CalendarProviderType, completion: @escaping CalendarServiceResponse) {
    remote.deleteAllEvent(type: type)
  }
}
