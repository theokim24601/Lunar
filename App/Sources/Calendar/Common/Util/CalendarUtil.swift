//
//  CalendarUtil.swift
//  Lunar
//
//  Created by hbkim on 2023/02/15.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

class CalendarUtil {
  static let yearLength = 4
  static let monthLength = 2
  static let dayLength = 2

  static func nearestFutureSolarIncludingToday(month: Int?, day: Int?) -> Date? {
    let dateComps = DateComponents(month: month, day: day)
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

  static func nearestFutureSolarIncludingToday(month ms: String?, day ds: String?) -> Date? {
    guard let ms, let month = Int(ms), let ds, let day = Int(ds) else { return nil }
    let dateComps = DateComponents(month: month, day: day)
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

  static func verifyDate(month ms: String?, day ds: String?) -> Bool {
    guard
      let ms, ms.count == monthLength,
      let m = Int(ms),
      let ds, ds.count == dayLength,
      let d = Int(ds)
    else { return false }

    let dateComps = DateComponents(
      calendar: .current,
      year: Date.current.year,
      month: m,
      day: d
    )
    return dateComps.isValidDate
  }
}
