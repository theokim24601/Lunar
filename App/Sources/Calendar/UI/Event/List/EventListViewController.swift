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
  var lastUpdatedIndex = -1

  override func viewDidLoad() {
    super.viewDidLoad()
    let move = CGAffineTransform(translationX: 30, y: 0)
    writeButton.transform = move
    writeButton.alpha = 0

    UIView.animate(withDuration: 0.5, delay: 0.7, options: .curveEaseOut, animations: {
      self.writeButton.transform = CGAffineTransform.identity
      self.writeButton.alpha = 1
    })
  }

  override func setupViews() {
    setupNavigationBar(title: "음력 일정")
    let fadeTextAnimation = CATransition()
    fadeTextAnimation.duration = 0.5
    fadeTextAnimation.type = .fade
    navigationController?.navigationBar.layer.add(fadeTextAnimation, forKey: "fadeText")
    navigationItem.rightBarButtonItem = UIBarButtonItem().apply {
      $0.image = "btn_setting".uiImage
      $0.tintColor = .el_navi_setting
      $0.style = .plain
      $0.target = self
      $0.action = #selector(settingWasTapped)
    }

    tableView = UITableView().apply {
      $0.rowHeight = UITableView.automaticDimension
      $0.separatorStyle = .none
      $0.dataSource = self
      $0.delegate = self
      $0.backgroundColor = .el_tableView
      $0.sectionFooterHeight = 0
      $0.tableFooterView = UIView()
      $0.alwaysBounceVertical = false
      let topPadding: CGFloat = 40
      $0.contentInset.top = topPadding
      $0.contentOffset.y = -topPadding
      $0.register(cell: EventCell.self)
      $0.register(cell: PlaceholdCell.self)
      view.addSubview($0)
    }

    topBackgroundView = UIImageView().apply {
      $0.image = "t1l_bg_event_list_top".uiImage
      $0.contentMode = .scaleToFill
      view.addSubview($0)
    }

    writeButton = UIButton().apply {
      let addImage = "btn_event_add".uiImage?.withRenderingMode(.alwaysTemplate)
      $0.setImage(addImage, for: .normal)
      $0.setImage(addImage, for: .highlighted)
      $0.tintColor = .el_write_tint
      $0.backgroundColor = .el_write_background
      $0.layer.cornerRadius = 30
      $0.layer.shadowColor = UIColor.gray.cgColor
      $0.layer.shadowOpacity = 1.0
      $0.layer.shadowOffset = .zero
      $0.layer.shadowRadius = 4
      $0.addTarget(self, action: #selector(writingWasTouchedDown), for: .touchDown)
      $0.addTarget(self, action: #selector(writingWasTouchedUpInside), for: .touchUpInside)
      $0.addTarget(self, action: #selector(writingWasTouchedUpOutside), for: .touchUpOutside)
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
      self.backgroundHeightConstraint = $0.height.equalTo(Const.topBackgroundMaxHeight).constraint
    }
    backgroundHeightConstraint?.activate()
    writeButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-16)
      $0.bottom.equalToSuperview().offset(-40)
      $0.width.height.equalTo(60)
    }
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    reload()
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
    Vibration.medium.vibrate()
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
        }
      })
  }

  @objc func writingWasTouchedUpOutside() {
    UIView.animate(withDuration: 0.2) {
      self.writeButton.transform = CGAffineTransform.identity
    }
  }

  func reload() {
    let newEvents = eventUseCase?.getAll() ?? []

    lastUpdatedIndex = -1
    if events.count < newEvents.count {
      for i in 0..<events.count {
        if let old = events[i].id, let new = newEvents[i].id, old != new {
          lastUpdatedIndex = i
          break
        }
      }
    }
    events = newEvents
    tableView.reloadData()
  }
}

extension EventListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if events.count == 0 {
      return 1
    } else {
      return events.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if events.count == 0 {
      let cell = tableView.dequeue(PlaceholdCell.self)!
      return cell
    } else {
      let cell = tableView.dequeue(EventCell.self)!
      cell.event = events[indexPath.row]
      return cell
    }
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let currentIndex = indexPath.row
    if lastUpdatedIndex > -1, currentIndex == lastUpdatedIndex, lastUpdatedIndex < events.count - 1 {
      let move = CGAffineTransform(translationX: 20, y: 0)
      cell.transform = move
      cell.alpha = 0

      UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
        cell.transform = CGAffineTransform.identity
        cell.alpha = 1
      })
      lastLoadedIndex = events.count - 1
    } else if currentIndex > lastLoadedIndex {
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
    if events.count == 0 {
      Vibration.medium.vibrate()
      eventEditFlow?(.new)
    } else {
      Vibration.medium.vibrate()
      eventEditFlow?(.edit(events[indexPath.row]))
    }
  }
}
