//
//  Date+Additions.swift
//  Lunar
//
//  Created by hbkim on 2023/11/16.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

extension Date {
  static let current = Date()

  var year: Int {
    let components = Calendar.current.dateComponents([.year], from: self)
    return components.year ?? 0
  }

  var yearString: String {
    return "\(year)"
  }

  var month: Int {
    let components = Calendar.current.dateComponents([.month], from: self)
    return components.month ?? 0
  }

  var monthString: String {
    return "\(month)".leftPadding(toLength: CalendarUtil.monthLength, withPad: "0")
  }

  var day: Int {
    let components = Calendar.current.dateComponents([.day], from: self)
    return components.day ?? 0
  }

  var dayString: String {
    return "\(day)".leftPadding(toLength: CalendarUtil.dayLength, withPad: "0")
  }
}

// MARK: - Date(String)

extension Date {
  func stringForLunar() -> String {
    let year = "\(Calendar.gregorian.component(.year, from: self))년 "
    let formatter = DateFormatter.defaultDateFormatter(calendar: .chinese)
    return year + formatter.string(from: self)
  }

  func stringForSolar() -> String {
    let gregorian = Calendar.gregorian
    var formatter: DateFormatter
    if self.year > Date.current.year {
      formatter = DateFormatter.default2DateFormatter(calendar: gregorian)
    } else {
      formatter = DateFormatter.defaultDateFormatter(calendar: gregorian)
    }
    return formatter.string(from: self)
  }
}

extension DateFormatter {
  static func defaultDateFormatter(calendar: Calendar) -> DateFormatter {
    return DateFormatter().apply {
      $0.dateFormat = "M월 d일"
      $0.locale = .current
      $0.calendar = calendar
    }
  }

  static func default2DateFormatter(calendar: Calendar) -> DateFormatter {
    return DateFormatter().apply {
      $0.dateFormat = "YYYY년 M월 d일"
      $0.locale = .current
      $0.calendar = calendar
    }
  }
}
