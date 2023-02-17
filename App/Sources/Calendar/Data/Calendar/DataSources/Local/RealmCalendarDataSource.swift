//
//  RealmCalendarDataSource.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

import RealmSwift

final class RealmCalendarDataSource: CalendarLocalDataSource {
  func findAll() -> [Event] {
    let realm = try! Realm()
    return realm.objects(RealmEvent.self)
      .map { $0.toEntity() }
  }

  func find(id: String) throws -> Event {
    let realm = try! Realm()
    guard let event = realm.object(ofType: RealmEvent.self, forPrimaryKey: id) else {
      throw CalendarError.eventNotExistsInCalendar
    }
    return event.toEntity()
  }

  func insert(event: Event) throws -> Event {
    let realm = try! Realm()
    do {
      return try realm.write {
        let realmEvent = realm.create(RealmEvent.self, value: RealmEvent(event: event), update: .all)
        return realmEvent.toEntity()
      }
    } catch {
      throw CalendarError.eventNotAddedToCalendar
    }
  }

  func update(event: Event) throws -> Event {
    let realm = try! Realm()
    do {
      let realmEvent = RealmEvent(event: event)
      guard let originRealmEvent = realm.object(ofType: RealmEvent.self, forPrimaryKey: realmEvent.id) else {
        throw CalendarError.eventNotExistsInCalendar
      }
      return try realm.write {
        originRealmEvent.title = event.title
        originRealmEvent.month = event.lunarMonth
        originRealmEvent.day = event.lunarDay
        originRealmEvent.syncCalendar = event.syncCalendar
        return originRealmEvent.toEntity()
      }
    } catch {
      throw CalendarError.eventNotUpdatedToCalendar
    }
  }

  func delete(id: String) throws -> Event {
    let realm = try! Realm()
    do {
      guard let realmEvent = realm.object(ofType: RealmEvent.self, forPrimaryKey: id) else {
        throw CalendarError.eventNotExistsInCalendar
      }
      let event = realmEvent.toEntity()
      try realm.write {
        realm.delete(realmEvent)
      }
      return event
    } catch {
      throw CalendarError.eventNotRemovedFromCalendar
    }
  }
}
