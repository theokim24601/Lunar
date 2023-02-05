//
//  CalendarLocalDataSource.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

final class CalendarLocalDataSource: CalendarLocalDataSourceType {

  private var database: CalendarDatabase

  init(database: CalendarDatabase) {
    self.database = database
  }

  func selectEvents() -> [RealmEvent] {
    return database.events()
  }

  func selectEvent(id: String) -> RealmEvent? {
    return database.event(id: id)
  }

  func insertEvent(event: RealmEvent, completion: (Result<RealmEvent, CalendarError>) -> Void) {
    database.create(event: event, completion: completion)
  }

  func updateEvent(event: RealmEvent, completion: (Result<RealmEvent, CalendarError>) -> Void) {
    database.create(event: event, completion: completion)
  }

  func deleteEvent(id: String, completion: (Result<Bool, CalendarError>) -> Void) {
    database.delete(id: id, completion: completion)
  }
}
