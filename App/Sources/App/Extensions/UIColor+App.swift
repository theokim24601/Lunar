//
//  UIColor+App.swift
//  Lunar
//
//  Created by hbkim on 2023/01/29.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import SwiftUI
import TheodoreCore

public extension UIColor {
  // MARK: - Splash
  static let sp_background = t1l_f2

  // MARK: - Event List
  static let el_background = t1l_f3
  static let el_navi_title = t1l_f3
  static let el_navi_setting = t1l_f3
  static let el_tableView = el_background
  static let el_write_tint = el_background
  static let el_write_background = t1l_f1

  // MARK: - EventCell
  static let ec_title = t1l_t1
  static let ec_lunarLabel = t1l_t1
  static let ec_gregorianLabel = t1l_t1

  // MARK: - PlaceholdCell
  static let ph_title = t1l_t3

  // MARK: - Event Edit
  static let ee_title = t1l_t1
  static let ee_dateLabel = grayAAA
  static let ee_lunarLabel = t1l_t1
  static let ee_gregorianLabel = t1l_t1
  static let ee_detail = grayAAA
  static let ee_calendarImgTint = t1l_f5
  static let ee_calendarImgTint_disable = t1l_f3
  static let ee_calendarReg = t1l_t1
  static let ee_calendarReg_disable = t1l_t4
  static let ee_calendarSwitchTint = t1l_f1
  static let ee_sync_warn = warnColor1
  static let ee_edit = t1l_f1
  static let ee_edit_disable = t1l_f4
  static let ee_date_editable = t1l_t1
  static let ee_date_disable = t1l_t4
  static let ee_date_slash = t1l_t4

  // MARK: - SettingCell
  static let sc_icon = t1l_f5
  static let sc_title = t1l_t1
}

// MARK: - Event Edit
public extension UIColor {
  static var dimmedBackground: UIColor = .init(
    light: .init(r: 158, g: 48, b: 254, a: 1),
    dark: .init(r: 158, g: 48, b: 254, a: 1)
  )
}

public extension UIColor {
  static let t1l_f1 = UIColor(hex: 0x3E32FF)
  static let t1l_f2 = UIColor(hex: 0xD0CEEF)
  static let t1l_f3 = UIColor(hex: 0xF8F8FF)
  static let t1l_f4 = UIColor(hex: 0xF7F7FA)
  static let t1l_f5 = UIColor(hex: 0x4A4963)

  static let t1l_t1 = UIColor(hex: 0x141240)
  static let t1l_t2 = UIColor(hex: 0x64619D)
  static let t1l_t3 = UIColor(hex: 0xC2C2D1)
  static let t1l_t4 = UIColor(hex: 0xE0DFED)

  static let warnColor1 = UIColor(hex: 0xFF3232)

  static let grayAAA = UIColor(hex: 0xAAAAAA)
  static let grayEEE = UIColor(hex: 0xEEEEEE)
}
