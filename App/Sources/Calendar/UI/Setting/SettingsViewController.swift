//
//  SettingsViewController.swift
//  Lunar
//
//  Created by hbkim on 2023/11/02.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import SnapKit

final class SettingsViewController: BaseViewController {
  struct Const {
    static let topBackgroundInset: CGFloat = 40
    static let topBackgroundMargin: CGFloat = 28
  }

  private var topBackgroundView: UIImageView!
  private var tableView: UITableView!

  private var backgroundBottomConstraint: Constraint?

  var eventUseCase: EventUseCase?
  var syncUseCase: SyncUseCase?
  var settings: [Int: [SettingCellForm]] = [:]

  var calendarSettingFlow: (() -> Void)?

  override func viewDidLoad() {
    super.viewDidLoad()
    reload()
  }

  override func setupViews() {
    setupNavigationBar(title: "설정")

    tableView = UITableView(frame: .zero, style: .grouped).apply {
      $0.rowHeight = UITableView.automaticDimension
      $0.separatorStyle = .none
      $0.dataSource = self
      $0.delegate = self
      $0.backgroundColor = .el_tableView
      $0.sectionFooterHeight = 0
      $0.tableFooterView = UIView()
      $0.alwaysBounceVertical = false
      $0.contentInset.top = Const.topBackgroundInset
      $0.contentOffset.y = -Const.topBackgroundInset
      $0.register(cell: SettingCell.self)
      $0.register(cell: SettingHeaderView.self)
      view.addSubview($0)
    }

    topBackgroundView = UIImageView().apply {
      $0.image = "t1l_bg_event_list_top".uiImage
      $0.contentMode = .scaleToFill
      view.addSubview($0)
    }
  }

  override func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    topBackgroundView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top)
      $0.leading.trailing.equalToSuperview()
      self.backgroundBottomConstraint = $0.bottom.equalTo(tableView.snp.top).offset(Const.topBackgroundMargin).constraint
    }
    backgroundBottomConstraint?.activate()
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let topInset = scrollView.contentInset.top
    let y = scrollView.contentOffset.y
    if topInset + y > 0 {
      backgroundBottomConstraint?.update(offset: Const.topBackgroundMargin)
    } else {
      let drag = -(topInset + y)
      backgroundBottomConstraint?.update(offset: Const.topBackgroundMargin + drag)
    }
  }
}

extension SettingsViewController: UITableViewDataSource {
  func reload() {
    settings = [
      0: [
        SettingCellForm(icon: "ic_setting_sync".uiImage!, title: "캘린더 연동", action: calendarSettingFlow),
        SettingCellForm(icon: "ic_setting_trash".uiImage!, title: "모든 일정 지우기", action: { self.showDeleteAlert() })
      ]
//      1: [
//        SettingCellForm(icon: "ic_setting_news".uiImage!, title: "도움말"),
//        SettingCellForm(icon: "ic_setting_news".uiImage!, title: "개인정보 처리방침"),
//        SettingCellForm(icon: "ic_setting_inquire".uiImage!, title: "오픈소스")
//      ],
//      2: [
//        SettingCellForm(icon: "ic_setting_news".uiImage!, title: "앱 공유"),
//        SettingCellForm(icon: "ic_setting_news".uiImage!, title: "리뷰 작성하기"),
//        SettingCellForm(icon: "ic_setting_inquire".uiImage!, title: "개발자 커피사주기")
//      ]
//      3: [
//        SettingCellForm(icon: "ic_setting_inquire".uiImage!, title: "MEDIAMUG")
//        SettingCellForm(icon: "ic_setting_inquire".uiImage!, title: "오늘 한 줄")
//        SettingCellForm(icon: "ic_setting_inquire".uiImage!, title: "오늘 할 일")
//      ]
    ]
    tableView.reloadData()
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return settings.count
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let cell = tableView.dequeue(SettingHeaderView.self)!
    if section == 0 {
      cell.titleLabel.text = "기본 설정"
    } else if section == 1 {
      cell.titleLabel.text = "지원"
    } else if section == 2 {
      cell.titleLabel.text = "음력을 알려줘 응원"
    }
    return cell
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings[section]?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(SettingCell.self)!
    cell.setting = settings[indexPath.section]?[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let move = CGAffineTransform(translationX: 0, y: 10)
    cell.transform = move
    cell.alpha = 0

    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      cell.transform = CGAffineTransform.identity
      cell.alpha = 1
    })
  }

  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let move = CGAffineTransform(translationX: 0, y: 10)
    view.transform = move
    view.alpha = 0

    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
      view.transform = CGAffineTransform.identity
      view.alpha = 1
    })
  }
}

extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    Vibration.medium.vibrate()
    if let form = settings[indexPath.section]?[indexPath.row] {
      form.action?()
    }
  }
}

extension SettingsViewController {
  func showDeleteAlert() {
    let deleteAction = UIAlertAction(title: "일정 삭제", style: .destructive) { _ in
      Task {
        let _ = await self.eventUseCase?.deleteAll()
      }
    }
    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
    let alert = UIAlertController(title: "모든 일정 삭제", message: "삭제된 일정은 복구할 수 없습니다.", preferredStyle: .alert)
    alert.addAction(deleteAction)
    alert.addAction(cancelAction)
    Task {
      await MainActor.run {
        present(alert, animated: true)
      }
    }
  }
}
