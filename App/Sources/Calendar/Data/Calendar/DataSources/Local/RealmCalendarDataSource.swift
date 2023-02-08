//
//  RealmCalendarDataSource.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

import RealmSwift

final class RealmCalendarDataSource: CalendarLocalDataSource {

  func selectEvents() -> [RealmEvent] {
    let realm = try! Realm()
    let events = realm.objects(RealmEvent.self)
    return events.filter { _ in true }
  }

  func selectEvent(id: String) -> RealmEvent? {
    let realm = try! Realm()
    return realm.object(ofType: RealmEvent.self, forPrimaryKey: id)
  }

  func insertEvent(event: RealmEvent, completion: (Result<RealmEvent, CalendarError>) -> Void) {
    do {
      let realm = try! Realm()
      try realm.write {
        let realmEvent = realm.create(RealmEvent.self, value: event, update: .all)
        completion(.success(realmEvent))
      }
    } catch {
      completion(.failure(.eventNotAddedToCalendar))
    }
  }

  func updateEvent(event: RealmEvent, completion: (Result<RealmEvent, CalendarError>) -> Void) {
    do {
      let realm = try! Realm()
      try realm.write {
        let realmEvent = realm.create(RealmEvent.self, value: event, update: .all)
        completion(.success(realmEvent))
      }
    } catch {
      completion(.failure(.eventNotAddedToCalendar))
    }
  }

  func deleteEvent(id: String, completion: (Result<Bool, CalendarError>) -> Void) {
    do {
      let realm = try! Realm()
      try realm.write {
        guard
          let event = realm.object(ofType: RealmEvent.self, forPrimaryKey: id)
          else {
            completion(.failure(.eventNotRemovedFromCalendar))
            return
        }
        realm.delete(event)
        completion(.success(true))
      }
    } catch {
      completion(.failure(.eventNotRemovedFromCalendar))
    }
  }
}
