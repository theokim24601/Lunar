//
//  CalendarRepository.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

final class CalendarRepositoryImpl: CalendarRepository {
  private let local: CalendarLocalDataSource
  private let remote: CalendarRemoteDataSource

  init(local: CalendarLocalDataSource, remote: CalendarRemoteDataSource) {
    self.local = local
    self.remote = remote
  }

  func events() -> [Event] {
    let events = local.selectEvents()
      .map { $0.toEntity() }
    return events
  }

  func newEvent(event: Event, providers: [CalendarProvider]) async throws -> Event {
    let newEvent = try local.insert(event: event)

    for provider in providers {
      try remote.insert(event: newEvent, provider: provider)
    }
    return newEvent
  }

  func updateEvent(event: Event, providers: [CalendarProvider]) async throws -> Event {
    guard let id = event.id , let old = local.find(id: id) else {
      throw CalendarError.eventNotExistsInCalendar
    }

    let newEvent = try local.update(event: event)
    for provider in providers {
      try remote.update(old: old, new: event, provider: provider)
    }
    return newEvent
  }

  func deleteEvent(_ id: String, providers: [CalendarProvider]) async throws {
    let event = try local.delete(id: id)

    for provider in providers {
      try remote.delete(event: event, provider: provider)
    }
  }


  func syncCalendar(provider: CalendarProvider) throws {
    let events = local.findAll()

    for event in events {
      try remote.insert(event: event, provider: provider)
    }
  }

  func unsyncCalendar(provider: CalendarProvider) throws {
    remote.deleteAll(provider: provider)
  }
}
