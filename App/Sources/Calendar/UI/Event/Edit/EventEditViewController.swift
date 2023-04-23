//
//  EventEditViewController.swift
//  Lunar
//
//  Created by hbkim on 2023/11/16.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import TheodoreCore
import TheodoreUI
import SnapKit

enum EventEditMode: Equatable {
  case new
  case edit(Event)

  var eventTitle: String? {
    switch self {
    case .new: return ""
    case .edit(let event): return event.title
    }
  }
}

final class EventEditViewController: BottomSheetView, UITextFieldDelegate {

  private var contentView: UIStackView!
  private var titleField: UITextField!
  private var lunarDateForm: DateFormView!
  private var solarDateForm: DateFormView!
  private var editContainerView: UIStackView!
  private var calendarSyncSwitch: UISwitch!
  private var calendarSyncNoticeLabel: UILabel!
  private var createButton: UIButton!
  private var editButton: UIButton!
  private var deleteButton: UIButton!

  var mode: EventEditMode
  var eventUseCase: EventUseCase
  var current: EventForm = EventForm()
  var didEditFinish: ((Bool) -> Void)?

  var defaultSyncValue: Bool

  init(mode: EventEditMode, eventUseCase: EventUseCase, syncUseCase: SyncUseCase) {
    self.mode = mode
    defaultSyncValue = syncUseCase.currentSettings().hasProvider
    current.syncCalendar = defaultSyncValue
    if case .edit(let event) = mode {
      current.id = event.id
      current.title = event.title
      current.month = event.lunarMonth
      current.day = event.lunarDay
      current.syncCalendar = event.syncCalendar
    }
    self.eventUseCase = eventUseCase

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setupViews() {
    super.setupViews()
    contentView = UIStackView().apply {
      $0.axis = .vertical
      $0.alignment = .fill
      $0.distribution = .fill
      $0.backgroundColor = .white
      containerView.addSubview($0)
    }

    BottomSheetHandleBar().apply {
      $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedWasTapped)))
      contentView.addArrangedSubview($0)
    }

    SizedView(height: 8).apply {
      contentView.addArrangedSubview($0)
    }

    titleField = UITextField().apply {
      $0.text = mode.eventTitle
      $0.placeholder = "제목을 입력해주세요"
      $0.font = .preferredFont(.medium, size: 16)
      $0.textColor = .ee_title
      $0.autocorrectionType = .no
      $0.autocapitalizationType = .none
      $0.enablesReturnKeyAutomatically = true
      $0.returnKeyType = .next
      $0.delegate = self
      $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
      contentView.addArrangedSubview($0)
    }

    SizedView(height: 20).apply {
      contentView.addArrangedSubview($0)
    }

    UILabel().apply {
      $0.font = .preferredFont(.medium, size: 12)
      $0.textColor = .ee_dateLabel
      $0.text = "날짜"
      contentView.addArrangedSubview($0)
    }

    SizedView(height: 8).apply {
      contentView.addArrangedSubview($0)
    }

    UIStackView().apply { stackView in
      stackView.axis = .horizontal
      stackView.alignment = .fill
      stackView.distribution = .fill
      contentView.addArrangedSubview(stackView)

      UILabel().apply {
        $0.font = .preferredFont(.medium, size: 16)
        $0.textColor = .ee_lunarLabel
        $0.text = "음력 날짜"
        stackView.addArrangedSubview($0)
      }

      lunarDateForm = DateFormView(
        short: true,
        editable: true,
        calendar: .chinese,
        year: nil,
        month: current.monthString,
        day: current.dayString
      ).apply {
        $0.dateChanged = { [weak self] month, day in
          guard let self else { return }
          guard CalendarUtil.verifyDate(month: month, day: day) else {
            self.disableButtons()
            return
          }

          self.current.month = Int(month)
          self.current.day = Int(day)

          if let date = CalendarUtil.nearestFutureSolarIncludingToday(month: self.current.month, day: self.current.day) {
            self.solarDateForm.updateDate(year: date.yearString, month: date.monthString, day: date.dayString)
          } else {
            self.solarDateForm.updateDate(year: nil, month: nil, day: nil)
          }
          self.validateForm()
        }
        stackView.addArrangedSubview($0)
      }
    }

    SizedView(height: 12).apply {
      contentView.addArrangedSubview($0)
    }

    UIStackView().apply { stackView in
      stackView.axis = .horizontal
      stackView.alignment = .fill
      stackView.distribution = .fill
      contentView.addArrangedSubview(stackView)

      UILabel().apply {
        $0.font = .preferredFont(.medium, size: 16)
        $0.textColor = .ee_gregorianLabel
        $0.text = "가까운 미래 날짜"
        stackView.addArrangedSubview($0)
      }

      var year, month, day: String?
      if case .edit = mode {
        let date = CalendarUtil.nearestFutureSolarIncludingToday(month: current.month, day: current.day)
        year = date?.yearString
        month = date?.monthString
        day = date?.dayString
      }
      solarDateForm = DateFormView(
        short: false,
        editable: false,
        calendar: .gregorian,
        year: year,
        month: month,
        day: day
      ).apply {
        stackView.addArrangedSubview($0)
      }
    }

    SizedView(height: 20).apply {
      contentView.addArrangedSubview($0)
    }

    UILabel().apply {
      $0.font = .preferredFont(.medium, size: 12)
      $0.textColor = .ee_detail
      $0.text = "상세"
      contentView.addArrangedSubview($0)
    }

    SizedView(height: 4).apply {
      contentView.addArrangedSubview($0)
    }

    UIStackView().apply { stackView in
      stackView.axis = .horizontal
      stackView.alignment = .center
      stackView.distribution = .fill
      stackView.spacing = 8
      contentView.addArrangedSubview(stackView)

      UIImageView().apply {
        if defaultSyncValue {
          $0.image = "t1l_ic_cloud".uiImage
        } else {
          $0.image = "t1l_ic_cloud_disable".uiImage
        }
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.addArrangedSubview($0)
      }

      UILabel().apply {
        $0.font = .preferredFont(.medium, size: 16)
        $0.text = "캘린더에 등록"
        if defaultSyncValue {
          $0.textColor = .ee_calendarReg
        } else {
          $0.textColor = .ee_calendarReg_disable
        }
        stackView.addArrangedSubview($0)
      }

      calendarSyncSwitch = UISwitch().apply {
        $0.onTintColor = .ee_calendarSwitchTint
        if defaultSyncValue {
          $0.isOn = current.syncCalendar
        } else {
          $0.isOn = false
        }
        $0.addTarget(self, action: #selector(syncWasChanged(_:)), for: .valueChanged)
        stackView.addArrangedSubview($0)
      }
    }

    calendarSyncNoticeLabel = UILabel().apply {
      $0.text = "설정에서 캘린더를 먼저 연동해주세요."
      $0.font = .preferredFont(.light, size: 11)
      $0.textColor = .ee_sync_warn
      $0.isHidden = true
      contentView.addArrangedSubview($0)
    }

    SizedView(height: 20).apply {
      contentView.addArrangedSubview($0)
    }

    editContainerView = UIStackView().apply { stackView in
      stackView.axis = .horizontal
      stackView.alignment = .fill
      stackView.distribution = .fill
      stackView.spacing = 8

      let cornerRadius = 8.0
      contentView.addArrangedSubview(stackView)

      deleteButton = UIButton().apply {
        $0.backgroundColor = .white
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.warnColor1, for: .normal)
        $0.titleLabel?.font = .preferredFont(.medium, size: 14)
        $0.layer.borderColor = UIColor.warnColor1.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = cornerRadius
        $0.isHidden = true
        $0.addTarget(self, action: #selector(deleteWasTapped(_:)), for: .touchUpInside)
        stackView.addArrangedSubview($0)
      }

      editButton = UIButton().apply {
        $0.backgroundColor = .ee_edit
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .preferredFont(.medium, size: 14)
        $0.layer.cornerRadius = cornerRadius
        $0.isHidden = true
        $0.addTarget(self, action: #selector(editWasTapped(_:)), for: .touchUpInside)
        stackView.addArrangedSubview($0)
      }

      createButton = UIButton().apply {
        $0.backgroundColor = .ee_edit
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .preferredFont(.medium, size: 14)
        $0.layer.cornerRadius = cornerRadius
        $0.isHidden = true
        $0.addTarget(self, action: #selector(createWasTapped(_:)), for: .touchUpInside)
        stackView.addArrangedSubview($0)
      }
    }

    SizedView(height: 28).apply {
      contentView.addArrangedSubview($0)
    }

    validateForm()
  }

  override func setupConstraints() {
    super.setupConstraints()
    contentView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.top.bottom.equalToSuperview()
    }

    let buttonHeight = 40.f
    deleteButton.snp.makeConstraints {
      $0.height.equalTo(buttonHeight)
    }

    editButton.snp.makeConstraints {
      $0.width.equalTo(deleteButton)
      $0.height.equalTo(buttonHeight)
    }

    createButton.snp.makeConstraints {
      $0.height.equalTo(buttonHeight)
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if case .new = mode {
      Timer.scheduledTimer(withTimeInterval: 0.4, repeats: false) { [weak self] _ in
        self?.titleField?.becomeFirstResponder()
      }
    }
  }

  @objc func textFieldDidChange(_ sender: Any) {
    current.title = titleField.text
    validateForm()
  }

  @objc func syncWasChanged(_ sendor: Any) {
    if !defaultSyncValue {
      calendarSyncSwitch.isOn = false
      calendarSyncNoticeLabel.isHidden = false
      return
    }
    current.syncCalendar = calendarSyncSwitch.isOn
    validateForm()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if lunarDateForm.becomeFirstResponder() {
      return true
    } else {
      return titleField.resignFirstResponder()
    }
  }

  func validateForm() {
    let title = current.title ?? ""
    let month = current.month
    let day = current.day
    let syncCalendar = current.syncCalendar
    let isValidDate = CalendarUtil.verifyDate(month: current.monthString, day: current.dayString)

    switch mode {
    case .new:
      if !title.isEmpty, isValidDate {
        enableButtons()
      } else {
        disableButtons()
      }
    case .edit(let event):
      let isSameAsOrigin = event.title == title
      && event.lunarMonth == month
      && event.lunarDay == day
      && event.syncCalendar == syncCalendar

      if isSameAsOrigin || title.isEmpty || !isValidDate {
        disableButtons()
      } else {
        enableButtons()
      }
    }
  }

  func enableButtons() {
    switch mode {
    case .new:
      createButton.isHidden = false
    case .edit:
      editButton.backgroundColor = .ee_edit
      editButton.isEnabled = true
      editButton.isHidden = false
      deleteButton.isHidden = false
    }
  }

  func disableButtons() {
    switch mode {
    case .new:
      createButton.isHidden = true
    case .edit:
      editButton.backgroundColor = .ee_edit_disable
      editButton.isEnabled = false
      editButton.isHidden = false
      deleteButton.isHidden = false
    }
  }

  @objc func createWasTapped(_ sender: Any) {
    Task {
      if let title = current.title,
         let month = current.month,
         let day = current.day {
        let syncCalendar = current.syncCalendar
        let event = Event(title: title, month: month, day: day, syncCalendar: syncCalendar)
        let result = await eventUseCase.newEvent(event)
        Task { @MainActor in
          switch result {
          case .success:
            didEditFinish?(true)
            Vibration.success.vibrate()
          case .failure:
            didEditFinish?(false)
          }
        }
      }
    }
  }

  @objc func editWasTapped(_ sender: Any) {
    Task {
      if let id = current.id,
         let title = current.title,
         let month = current.month,
         let day = current.day {
        let syncCalendar = current.syncCalendar
        let event = Event(id: id, title: title, month: month, day: day, syncCalendar: syncCalendar)
        let result = await eventUseCase.update(event)
        await MainActor.run {
          switch result {
          case .success:
            didEditFinish?(true)
            Vibration.success.vibrate()
          case .failure:
            didEditFinish?(false)
          }
        }
      }
    }
  }

  @objc func deleteWasTapped(_ sender: Any) {
    guard case let .edit(event) = mode else { return }
    guard let id = event.id else { return }
    Task {
      let result = await eventUseCase.delete(id)
      await MainActor.run {
        switch result {
        case .success:
          didEditFinish?(true)
          Vibration.success.vibrate()
        case .failure:
          didEditFinish?(false)
        }
      }
    }
  }
}
