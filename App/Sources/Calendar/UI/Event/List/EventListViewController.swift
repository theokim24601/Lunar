//
//  EventListViewController.swift
//  Lunar
//
//  Created by hbkim on 2023/10/12.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

final class EventListViewController: BaseViewController {
  struct Const {
    static let topBackgroundMaxHeight: CGFloat = 135
    static let topBackgroundMinHeight: CGFloat = 125
  }

  private var topBackgroundView: UIImageView!
  private var tableView: UITableView!
  private var settingButton: UIButton!
  private var writeButton: UIButton!

  private var backgroundHeightConstraint: Constraint?

  var eventEditFlow: ((EventEditMode) -> Void)?
  var settingFlow: (() -> Void)?
  var eventUseCase: EventUseCase?
  var events: [Event] = []

  var lastLoadedIndex = -1

  override func viewDidLoad() {
    super.viewDidLoad()
    reload()
  }

  override func setupViews() {
    let fadeTextAnimation = CATransition()
    fadeTextAnimation.duration = 0.5
    fadeTextAnimation.type = .fade

    view.backgroundColor = .el_background

    navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
    navigationItem.title = "음력 일정"
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

    navigationItem.rightBarButtonItem = UIBarButtonItem().apply {
      $0.image = "btn_setting".uiImage
      $0.tintColor = .el_navi_setting
      $0.style = .plain
      $0.target = self
      $0.action = #selector(settingWasTapped)
    }

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
    tableView.register(cell: EventCell.self)
    view.addSubview(tableView)

    topBackgroundView = UIImageView()
    topBackgroundView.image = "t1l_bg_event_list_top".uiImage
    topBackgroundView.contentMode = .scaleToFill
    view.addSubview(topBackgroundView)

    writeButton = UIButton()
    let addImage = "btn_event_add".uiImage?.withRenderingMode(.alwaysTemplate)
    writeButton.setImage(addImage, for: .normal)
    writeButton.setImage(addImage, for: .highlighted)
    writeButton.tintColor = .el_write_tint
    writeButton.backgroundColor = .el_write_background
    writeButton.layer.cornerRadius = 30
    writeButton.layer.shadowColor = UIColor.gray.cgColor
    writeButton.layer.shadowOpacity = 1.0
    writeButton.layer.shadowOffset = .zero
    writeButton.layer.shadowRadius = 4
    writeButton.addTarget(self, action: #selector(writingWasTouchedDown), for: .touchDown)
    writeButton.addTarget(self, action: #selector(writingWasTouchedUpInside), for: .touchUpInside)
    writeButton.addTarget(self, action: #selector(writingWasTouchedUpOutside), for: .touchUpOutside)
    view.addSubview(writeButton)
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
    writeButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-40)
      $0.width.height.equalTo(60)
    }
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

  @objc func settingWasTapped(_ sender: Any) {
    settingFlow?()
  }

  @objc func writingWasTouchedDown() {
    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
      self.writeButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
    }
  }

  @objc func writingWasTouchedUpInside() {
    UIView.animate(
      withDuration: 0.15,
      delay: 0,
      options: .curveEaseOut,
      animations: {
        Vibration.heavy.vibrate()
        self.writeButton.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
      },
      completion: { _ in
        UIView.animate(withDuration: 0.1) {
          self.writeButton.transform = CGAffineTransform.identity
          self.eventEditFlow?(.new)
          //          self.navigator?.show(.eventEdit(mode: .new, completion: self.reload), transition: .present)
        }
      })
  }

  @objc func writingWasTouchedUpOutside() {
    UIView.animate(withDuration: 0.2) {
      self.writeButton.transform = CGAffineTransform.identity
    }
  }

  func reload() {
//    events = eventUseCase?.getAll() ?? []
    events = [
      Event(id: "1", title: "어머니 생신", month: 10, day: 23, syncCalendar: false),
      Event(id: "2", title: "어머니 생신", month: 7, day: 23, syncCalendar: false)
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
//      Event(title: "어머니 생신", month: 10, day: 23),
    ]
    tableView.reloadData()

    let move = CGAffineTransform(translationX: 30, y: 0)
    writeButton.transform = move
    writeButton.alpha = 0

    UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: {
      self.writeButton.transform = CGAffineTransform.identity
      self.writeButton.alpha = 1
    })
  }
}

extension EventListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(EventCell.self)!
    cell.event = events[indexPath.row]
    return cell
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let currentIndex = indexPath.row
    if currentIndex > lastLoadedIndex {
      let move = CGAffineTransform(translationX: 0, y: 30)
      cell.transform = move
      cell.alpha = 0

      UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
        cell.transform = CGAffineTransform.identity
        cell.alpha = 1
      })
      lastLoadedIndex = currentIndex
    }
  }
}

extension EventListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    Vibration.medium.vibrate()
    eventEditFlow?(.edit(events[indexPath.row]))
//    navigator?.show(
//      .eventEdit(
//        mode: .edit(events[indexPath.row]),
//        completion: reload
//      ),
//      transition: .present
//    )
  }
}
