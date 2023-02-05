//
//  Date+Formatter.swift
//  Lunar
//
//  Created by hbkim on 2023/11/16.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

extension Date {
  static let current = Date()

  static var currentYear: Int {
    return current.year
  }

  var year: Int {
    let components = Calendar.current.dateComponents([.year], from: self)
    return components.year ?? 0
  }

  func toNearestFutureIncludingToday() -> Self? {
    var target = self
    let aYear = DateComponents(year: 1)
    while target.compare(Date.current) == .orderedAscending {
      let nextYearTarget = Calendar.chinese.date(byAdding: aYear, to: target)!
      target = nextYearTarget
    }
    return target
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
    if self.year > Date.currentYear {
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
