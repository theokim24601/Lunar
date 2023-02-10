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
    static let topBackgroundMaxHeight: CGFloat = 135
    static let topBackgroundMinHeight: CGFloat = 125
  }

  private var topBackgroundView: UIImageView!
  private var tableView: UITableView!

  private var backgroundHeightConstraint: Constraint?

  var syncUseCase: SyncUseCase?
  var settings: [SettingCellForm] = []

//  override func viewDidLoad() {
//    super.viewDidLoad()
////    tableView.register(UINib(nibName: "SyncCell", bundle: Bundle.main), forCellReuseIdentifier: "SyncCell")
//////    analytics.log(.setting_view)
////    loadSettings()
////    if #available(iOS 13, *) {
////      closeButton.isHidden = true
////    }
//  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reload()
  }

  override func setupViews() {
    view.backgroundColor = .el_background
    
    navigationItem.title = "설정"
    navigationController?.view.backgroundColor = .clear
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.largeTitleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.el_navi_title,
      NSAttributedString.Key.font: UIFont.preferredFont(.medium, size: 34)
    ]

    navigationController?.navigationBar.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.el_navi_title,
      NSAttributedString.Key.font: UIFont.preferredFont(.regular, size: 16)
    ]
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.backgroundColor = .clear
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.navigationBar.tintColor = .el_navi_title

    tableView = UITableView()
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.delegate = self
    tableView.backgroundColor = .el_tableView
    tableView.sectionFooterHeight = 0
    tableView.tableFooterView = UIView()
    tableView.alwaysBounceVertical = false
    let topPadding: CGFloat = 40
    tableView.contentInset.top = topPadding
    tableView.contentOffset.y = -topPadding
    tableView.register(cell: SettingCell.self)
    view.addSubview(tableView)

    topBackgroundView = UIImageView()
    topBackgroundView.image = "t1l_bg_event_list_top".uiImage
    topBackgroundView.contentMode = .scaleToFill
    view.addSubview(topBackgroundView)
  }

  override func setupConstraints() {
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    topBackgroundView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top)
      $0.leading.trailing.equalToSuperview()
      self.backgroundHeightConstraint = $0.height.equalTo(Const.topBackgroundMaxHeight).constraint
    }
    backgroundHeightConstraint?.activate()
  }

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let contentOffset = scrollView.contentOffset.y

    var minHeight: CGFloat = Const.topBackgroundMinHeight
    if let naviMaxY = navigationController?.navigationBar.frame.maxY {
      minHeight = naviMaxY + 28
    }

    var targetHeight = Const.topBackgroundMaxHeight - contentOffset
    targetHeight = max(minHeight, targetHeight)
    backgroundHeightConstraint?.update(offset: targetHeight)
  }

  func reload() {
    settings = [
      SettingCellForm(icon: "ic_setting_introduce".uiImage!, title: "앱 소개"),
      SettingCellForm(icon: "ic_setting_news".uiImage!, title: "새 소식"),
      SettingCellForm(icon: "ic_setting_inquire".uiImage!, title: "개발자에게 문의하기"),
      SettingCellForm(icon: "ic_setting_sync".uiImage!, title: "캘린더 연동"),
      SettingCellForm(icon: "ic_setting_trash".uiImage!, title: "모든 일정 지우기")
    ]
    tableView.reloadData()
  }
}

extension SettingsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(SettingCell.self)!
    cell.setting = settings[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let move = CGAffineTransform(translationX: 0, y: 20)
    cell.transform = move
    cell.alpha = 0

    UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
      cell.transform = CGAffineTransform.identity
      cell.alpha = 1
    })
  }
}

extension SettingsViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

  }
}
