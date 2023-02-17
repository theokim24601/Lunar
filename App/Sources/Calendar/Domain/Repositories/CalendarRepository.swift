//
//  CalendarRepository.swift
//  Lunar
//
//  Created by hbkim on 2023/11/27.
//  Copyright © 2023 theo. All rights reserved.
//

protocol CalendarRepository {
  func events() -> [Event]
  func newEvent(event: Event, providers: [CalendarProvider]) throws -> Event
  func updateEvent(event: Event, providers: [CalendarProvider]) throws -> Event
  func deleteEvent(_ id: String, providers: [CalendarProvider]) throws
  func deleteAll(providers: [CalendarProvider]) throws

  func verifyAuthorizationStatus(provider: CalendarProvider) async -> Bool
  func syncCalendar(provider: CalendarProvider) throws
  func unsyncCalendar(provider: CalendarProvider) throws
}
