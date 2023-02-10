//
//  CalendarDataSource.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

protocol CalendarLocalDataSource {
  func findAll() -> [Event]
  func find(id: String) throws -> Event
  func insert(event: Event) throws -> Event
  func update(event: Event) throws -> Event
  func delete(id: String) throws-> Event
}

protocol CalendarRemoteDataSource {
  var provider: CalendarProvider { get }

  func verifyAuthorizationStatus() async -> Bool
  func save(event: Event) throws
  func update(old: Event, new: Event) throws
  func remove(event: Event) throws
  func removeAll() throws
}
