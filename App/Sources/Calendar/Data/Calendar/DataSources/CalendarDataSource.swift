//
//  CalendarDataSource.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

protocol CalendarLocalDataSource {
  func find(id: String) -> Event?
  func findAll() -> [Event]
  func insert(event: Event) throws -> Event
  func update(event: Event) throws -> Event
  func delete(id: String) throws-> Event
}

protocol CalendarRemoteDataSource {
  func insert(event: Event, provider: CalendarProvider) throws
  func update(old: Event, new: Event, provider: CalendarProvider) throws
  func delete(event: Event, provider: CalendarProvider) throws
  func deleteAll(provider: CalendarProvider)
}
