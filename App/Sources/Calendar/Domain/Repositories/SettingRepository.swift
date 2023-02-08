//
//  SettingRepository.swift
//  Lunar
//
//  Created by hbkim on 2023/11/27.
//  Copyright © 2023 theo. All rights reserved.
//

protocol SettingRepository {
  var current: Settings { get }
  func updateProviderSetting(setting: CalendarProviderSetting) -> Bool
}
