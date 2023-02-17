//
//  EventForm.swift
//  Lunar
//
//  Created by hbkim on 2023/02/15.
//  Copyright © 2023 theo. All rights reserved.
//

struct EventForm {
  var id: String?
  var title: String?
  var month: Int?
  var day: Int?
  var syncCalendar: Bool = false

  var monthString: String? {
    if let month = month {
      return "\(month)".leftPadding(toLength: CalendarUtil.monthLength, withPad: "0")
    }
    return ""
  }

  var dayString: String? {
    if let day = day {
      return "\(day)".leftPadding(toLength: CalendarUtil.dayLength, withPad: "0")
    }
    return ""
  }
}
