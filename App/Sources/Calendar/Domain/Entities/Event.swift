//
//  Event.swift
//  Lunar
//
//  Created by hbkim on 2023/11/09.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation
import Scope

class Event: Identifiable, Equatable, Comparable {
  var id: String?
  var title: String
  var lunarMonth: Int
  var lunarDay: Int
  var syncCalendar: Bool

  init(id: String? = nil, title: String, month: Int, day: Int, syncCalendar: Bool) {
    self.id = id
    self.title = title
    self.lunarMonth = month
    self.lunarDay = day
    self.syncCalendar = syncCalendar
  }

  func copy() -> Event {
    return Event(
      id: id,
      title: title,
      month: lunarMonth,
      day: lunarDay,
      syncCalendar: syncCalendar
    )
  }

  static func == (lhs: Event, rhs: Event) -> Bool {
    return lhs.title == rhs.title
    && lhs.lunarMonth == rhs.lunarMonth
    && lhs.lunarDay == rhs.lunarDay
  }

  static func < (lhs: Event, rhs: Event) -> Bool {
    guard let date1 = CalendarUtil.nearestFutureSolarIncludingToday(month: lhs.lunarMonth, day: lhs.lunarDay) else { return true }
    guard let date2 = CalendarUtil.nearestFutureSolarIncludingToday(month: rhs.lunarMonth, day: rhs.lunarDay) else { return true }
    return date2.compare(date1) == .orderedDescending
  }
}
