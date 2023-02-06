//
//  Event.swift
//  Lunar
//
//  Created by hbkim on 2023/11/09.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation
import Scope

class Event: Equatable, Comparable {
  var id: String?
  var title: String?
  var date: Date? // lunar

  var lunarMonth: Int?
  var lunarDay: Int?

  init() {}

  init(title: String, month: Int, day: Int) {
    self.title = title
    self.lunarMonth = month
    self.lunarDay = day
  }

  init(event: RealmEvent) {
    self.id = event.id
    self.title = event.title
    self.date = event.date
  }

  init(event: Event) {
    self.id = event.id
    self.title = event.title
    self.date = event.date
    self.lunarMonth = event.lunarMonth
    self.lunarDay = event.lunarDay
  }

  func convertForRealm() -> RealmEvent {
    return RealmEvent().apply {
      if let id = self.id {
        $0.id = id
      }
      $0.title = self.title ?? ""
      $0.date = self.date ?? Date()
    }
  }

  func convertForRemote() -> Event {
    self.date = self.date?.toNearestFutureIncludingToday()
    return self
  }

  static func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.title == rhs.title
      && lhs.date == rhs.date
  }

  static func < (lhs: Event, rhs: Event) -> Bool {
    guard let date1 = lhs.date?.toNearestFutureIncludingToday() else { return true }
    guard let date2 = rhs.date?.toNearestFutureIncludingToday() else { return true }
    return date2.compare(date1) == .orderedDescending
  }

  func toNearestFutureIncludingToday() -> Date? {
    let dateComps = DateComponents(month: lunarMonth, day: lunarDay)
    guard var target = Calendar.chinese.date(from: dateComps) else {
      return nil
    }
    let aYear = DateComponents(year: 1)
    while target.compare(Date.current) == .orderedAscending {
      let nextYearTarget = Calendar.chinese.date(byAdding: aYear, to: target)!
      target = nextYearTarget
    }
    return target
  }

  func copy() -> Event {
    return Event(event: self)
  }
}
