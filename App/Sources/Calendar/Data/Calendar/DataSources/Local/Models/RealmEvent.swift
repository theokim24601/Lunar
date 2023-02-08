//
//  RealmEvent.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation
import RealmSwift

class RealmEvent: Object {
  @Persisted(primaryKey: true) var id: String = UUID().uuidString
  @Persisted var title: String = ""
  @Persisted var month: Int
  @Persisted var day: Int
  @Persisted var syncCalendar: Bool = false

  init(id: String?, title: String, month: Int, day: Int, syncCalendar: Bool) {
    if let id {
      self.id = id
    }
    self.title = title
    self.month = month
    self.day = day
    self.syncCalendar = syncCalendar
  }

  convenience init(event: Event) {
    self.init(
      id: event.id,
      title: event.title,
      month: event.lunarMonth,
      day: event.lunarDay,
      syncCalendar: event.syncCalendar
    )
  }

  func toEntity() -> Event {
    return Event(
      id: id,
      title: title,
      month: month,
      day: day,
      syncCalendar: syncCalendar
    )
  }
}
