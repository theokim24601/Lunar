//
//  CompositionRoot.swift
//  Lunar
//
//  Created by hbkim on 2023/10/19.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import Firebase

struct AppDependency {
  let window: UIWindow
  let configureSDKs: () -> Void
  let coordinator: AppCoordinator
}

struct CompositionRoot {
  static func resolve() -> AppDependency {
    let window = UIWindow().apply {
      $0.backgroundColor = .white
      $0.makeKeyAndVisible()
    }

    return AppDependency(
      window: window,
      configureSDKs: configureSDKs,
      coordinator: AppCoordinator(
        window: window,
        navigationController: UINavigationController()
      )
    )
  }

  static func configureSDKs() {
  }
}

extension CompositionRoot {
  static let eventUseCase: EventUseCase = {
    return EventUseCase(
      calendarRepository: calendarRepository,
      settingRepository: settingRepository
    )
  }()

  static let syncUseCase: SyncUseCase = {
    return SyncUseCase(
      calendarRepository: calendarRepository,
      settingRepository: settingRepository
    )
  }()

  static var settingRepository: SettingRepository = {
    return SettingRepositoryImpl()
  }()

  static var calendarRepository: CalendarRepository = {
    return CalendarRepositoryImpl(
      local: RealmCalendarDataSource(),
      remoteDataSources: [appleCalendarService]
    )
  }()

  static var appleCalendarService: CalendarRemoteDataSource = {
    return AppleCalendarService()
  }()
}
