//
//  AppCoordinator.swift
//  Lunar
//
//  Created by hbkim on 2023/11/18.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

fileprivate var launchWasShown = false

fileprivate enum LaunchInstructor {
  case launch
  case main

  static func configure(launchWasShown: Bool = launchWasShown) -> LaunchInstructor {
    return launchWasShown ? .main : .launch
  }
}

final class AppCoordinator {
  private let window: UIWindow
  private let navigationController: UINavigationController

  private var instructor: LaunchInstructor {
    return LaunchInstructor.configure()
  }

  init(
    window: UIWindow,
    navigationController: UINavigationController
  ) {
    self.window = window
    self.navigationController = navigationController
  }

  func start() {
    if instructor == .launch {
      runLaunchFlow()
      return
    }
    runEventListFlow()
  }

  private func runLaunchFlow() {
    let vc = LaunchViewController()
    vc.finishFlow = { [weak self] in
      launchWasShown = true
      self?.start()
    }
    navigationController.setViewControllers(
      [vc],
      animated: false
    )
    window.rootViewController = navigationController
  }

  private func runEventListFlow() {
    let vc = EventListViewController()
    vc.eventUseCase = CompositionRoot.eventUseCase
    vc.eventEditFlow = { [weak self] eventEditMode in
      self?.showEventEditFlow(eventEditMode: eventEditMode)
    }
    vc.settingFlow = { [weak self] in
      self?.pushSettingFlow()
    }
    navigationController.setViewControllers(
      [vc],
      animated: false
    )
    window.rootViewController = navigationController
  }

  private func showEventEditFlow(eventEditMode mode: EventEditMode) {
    let vc = EventEditViewController(
      mode: mode,
      eventUseCase: CompositionRoot.eventUseCase,
      syncUseCase: CompositionRoot.syncUseCase
    )
    vc.didEditFinish = { [weak self] updated in
      self?.navigationController.dismiss(animated: false)

      if updated, let listVC = self?.navigationController.children.first as? EventListViewController {
        listVC.reload()
      }
    }
    navigationController.present(vc, animated: false)
  }

  private func pushSettingFlow() {
    let vc = SettingsViewController()
    vc.calendarSettingFlow = { [weak self] in
      self?.showCalendarSyncView()
    }
    vc.eventUseCase = CompositionRoot.eventUseCase
    vc.syncUseCase = CompositionRoot.syncUseCase
    navigationController.pushViewController(vc, animated: true)
  }

  private func showCalendarSyncView() {
    let vc = CalendarSyncViewController(syncUseCase: CompositionRoot.syncUseCase)
    navigationController.present(vc, animated: false)
  }
}
