//
//  SettingRepositoryType.swift
//  Lunar
//
//  Created by hbkim on 2023/11/27.
//  Copyright © 2023 theo. All rights reserved.
//

protocol SettingRepositoryType {
  var current: Settings? { get }
  func updateSync(type: CalendarProviderType, sync: Bool) -> Bool
}
