//
//  EventEditViewController.swift
//  Lunar
//
//  Created by hbkim on 2023/11/16.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
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

  var eventDate: Date {
    switch self {
    case .new: return Date()
    case .edit(let event): return event.date ?? Date()
    }
  }
}


final class EventEditViewController: BaseViewController, UITextFieldDelegate {

  private let maxDimmedAlpha: CGFloat = 0.6
  private var dimmedView: UIView!

  private let containerDefaultHeight: CGFloat = 240
  private var containerView: UIView!

  private var contentView: UIStackView!
  private var dismissView: DismissView!
//  private var modeLabel: UILabel!

//  private var titleContainerView: UIView!
  private var titleField: UITextField!
  private var lunarDateForm: DateFormView!
  private var solarDateForm: DateFormView!

//  private var yearContainerView: UIView!
//  private var yearField: UITextField!

//  private var monthContainerView: UIView!
//  private var monthField: UITextField!

//  private var dayContainerView: UIView!
//  private var dayField: UITextField!
  private var editContainerView: UIStackView!
  private var createButton: UIButton!
  private var editButton: UIButton!
  private var deleteButton: UIButton!


//  var containerViewBottomConstraint: Constraint?
//  var keyboardPaddingHeightConstraint: Constraint?

//  var eventUseCase: EventUseCase?
//
  var mode: EventEditMode = .new
  lazy var current: Event = {
    var newEvent = Event()
    if case .edit(let event) = mode {
      newEvent = event.copy()
    }
    return newEvent
  }()
//  var current = Date() {
//    didSet {
//      yearField.text = "\(Calendar.gregorian.component(.year, from: current))"
//      monthField.text = "\(Calendar.chinese.component(.month, from: current))"
//      dayField.text = "\(Calendar.chinese.component(.day, from: current))"
//      datePicker.date = current
//    }
//  }
//
  var didEditFinish: (() -> Void)?
//
//  private lazy var toolbar: UIToolbar = {
//    let toolbar = UIToolbar()
//    toolbar.barStyle = .default
//    toolbar.isTranslucent = true
//    toolbar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
//    toolbar.sizeToFit()
//
//    let doneButton = UIBarButtonItem(
//      title: "Done",
//      style: .plain,
//      target: self,
//      action: #selector(endUpdateDate)
//    )
//    let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//    let cancelButton = UIBarButtonItem(
//      title: "Cancel",
//      style: .plain,
//      target: self,
//      action: #selector(cancelUpdateDate)
//    )
//    toolbar.setItems([cancelButton, spaceButton, doneButton], animated: false)
//    toolbar.isUserInteractionEnabled = true
//    return toolbar
//  }()
//
//  private lazy var datePicker: UIDatePicker = {
//    let datePicker = UIDatePicker()
//    datePicker.datePickerMode = .date
//    datePicker.timeZone = .current
//    datePicker.calendar = .chinese
//    return datePicker
//  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    registerForKeyboardNotifications()
  }

  private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  private func unregisterForKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
  }

  override func setupViews() {
    dimmedView = UIView()
    dimmedView.backgroundColor = .black
    dimmedView.alpha = maxDimmedAlpha
    dimmedView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dimmedWasTapped)))
    view.addSubview(dimmedView)

    containerView = UIView()
    containerView.backgroundColor = .white
    containerView.layer.cornerRadius = 16
    containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    view.addSubview(containerView)

    contentView = UIStackView()
    contentView.axis = .vertical
    contentView.alignment = .fill
    contentView.distribution = .fill
    contentView.backgroundColor = .white
    containerView.addSubview(contentView)

    DismissView().apply {
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

      lunarDateForm = DateFormView(short: true, editable: true, calendar: .chinese, year: nil, month: current.lunarMonth, day: current.lunarDay).apply {
        $0.completion = { [weak self] month, day in
          self?.current.lunarMonth = month
          self?.current.lunarDay = day

          if let date = self?.current.toNearestFutureIncludingToday() {
            self?.solarDateForm.updateDate(year: date.year, month: date.month, day: date.day)
          }
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

      var y, m, d: Int?
      if let date = current.toNearestFutureIncludingToday() {
        let comps = Calendar.gregorian.dateComponents([.year, .month, .day], from: date)
        y = comps.year
        m = comps.month
        d = comps.day
      }
      solarDateForm = DateFormView(short: false, editable: false, calendar: .gregorian, year: y, month: m, day: d).apply {
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
        $0.image = "t1l_ic_cloud".uiImage
        $0.tintColor = .ee_calendarImgTint
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        stackView.addArrangedSubview($0)
      }

      UILabel().apply {
        $0.font = .preferredFont(.medium, size: 16)
        $0.textColor = .ee_calendarReg
        $0.text = "캘린더에 등록"
        stackView.addArrangedSubview($0)
      }

      UISwitch().apply {
        $0.onTintColor = .ee_calendarSwitchTint
        $0.isOn = true
        stackView.addArrangedSubview($0)
      }
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
        $0.borderColor = .warnColor1
        $0.borderWidth = 1
        $0.cornerRadius = cornerRadius
        stackView.addArrangedSubview($0)
      }

      editButton = UIButton().apply {
        $0.backgroundColor = .ee_edit
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .preferredFont(.medium, size: 14)
        $0.cornerRadius = cornerRadius
        stackView.addArrangedSubview($0)
      }

      createButton = UIButton().apply {
        $0.backgroundColor = .ee_edit
        $0.setTitle("추가", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .preferredFont(.medium, size: 14)
        $0.cornerRadius = cornerRadius
        $0.isHidden = true
        stackView.addArrangedSubview($0)
      }

      if case .edit = mode {
        deleteButton.isHidden = false
        editButton.isHidden = false
      } else {
        deleteButton.isHidden = true
        editButton.isHidden = true
      }
      createButton.isHidden = true
    }

    SizedView(height: 28).apply {
      contentView.addArrangedSubview($0)
    }

//    containerView.layer.borderColor = UIColor(named: "border")?.cgColor
//    containerView.backgroundColor = UIColor(named: "background")
//
//    let titleColor = UIColor(named: "title")?.cgColor
//    titleContainerView.layer.borderColor = titleColor
//
//    yearContainerView.layer.borderColor = titleColor
//    yearField.inputAccessoryView = toolbar
//    yearField.inputView = datePicker
//
//    monthContainerView.layer.borderColor = titleColor
//    monthField.inputAccessoryView = toolbar
//    monthField.inputView = datePicker
//
//    dayContainerView.layer.borderColor = titleColor
//    dayField.inputAccessoryView = toolbar
//    dayField.inputView = datePicker
//
//    modeLabel.text = mode.modeTitle
//    titleField.text = mode.eventTitle
//    current = mode.startDate
//    switch mode {
//    case .new:
////      analytics.log(.create_view)
//      editButton.isHidden = true
//      deleteButton.isHidden = true
//      enableButton(button: createButton, enable: false)
//    case .edit(let event):
////      analytics.log(.edit_view(event))
//      createButton.isHidden = true
//      enableButton(button: editButton, enable: false)
//    }
  }

  override func setupConstraints() {
    dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    containerView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(containerDefaultHeight)
    }

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
    animateShowDimmedView()
    animatePresentContainer()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterForKeyboardNotifications()
  }

  @objc func keyboardWillShow(_ notification: NSNotification) {
    if let userInfo = notification.userInfo,
       let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
       let keyboardRect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
      UIView.animate(withDuration: duration, delay: 0, animations: {
        self.containerView.transform = CGAffineTransform(translationX: 0, y: -keyboardRect.height)
      })
    }
  }

  @objc func keyboardWillHide(_ notification: NSNotification) {
    containerView.transform = .identity
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }

  func animateShowDimmedView() {
    dimmedView.alpha = 0
    UIView.animate(withDuration: 0.4) {
      self.dimmedView.alpha = self.maxDimmedAlpha
    }
  }

  func animatePresentContainer() {
    containerView.snp.updateConstraints {
      $0.bottom.equalToSuperview()
    }
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }
  }

  @objc func dimmedWasTapped() {
    animateDismissView()
  }

  func animateDismissView() {
    containerView.snp.updateConstraints {
      $0.bottom.equalToSuperview().offset(contentView.frame.height)
    }
    UIView.animate(withDuration: 0.3) {
      self.view.layoutIfNeeded()
    }

    dimmedView.alpha = maxDimmedAlpha
    UIView.animate(withDuration: 0.4) {
      self.dimmedView.alpha = 0
    } completion: { _ in
      self.dismiss(animated: false)
    }
  }

//  private func switchBasedNextTextField(_ textField: UITextField) {
//      switch textField {
//      case self.username:
//          self.firstname.becomeFirstResponder()
//      case self.firstname:
//          self.lastname.becomeFirstResponder()
//      case self.lastname:
//          self.email.becomeFirstResponder()
//      default:
//          self.email.resignFirstResponder()
//      }
//  }

//  @IBAction func closingWasTapped(_ sender: Any) {
////    navigator?.pop(isModal: true)
//  }
//
//  @IBAction func createWasTapped(_ sender: Any) {
//    guard let eventTitle = titleField.text else { return }
//    let event = Event(title: eventTitle, date: current)
//    eventUseCase?.new(event)
//    didEditFinish?()
////    analytics.log(.event_create(event))
////    navigator?.pop(isModal: true)
//    Vibration.success.vibrate()
//  }
//
//  @IBAction func editWasTapped(_ sender: Any) {
//    guard let eventTitle = titleField.text else { return }
//    guard case let .edit(event) = mode else { return }
//    event.title = eventTitle
//    event.date = current
//    eventUseCase?.update(event)
//    didEditFinish?()
////    analytics.log(.event_edit)
////    navigator?.pop(isModal: true)
//    Vibration.success.vibrate()
//  }
//
//  @IBAction func deleteWasTapped(_ sender: Any) {
//    showDeleteAlert()
//  }
//
//  @IBAction func textFieldDidChange(_ sender: Any) {
//    validate(text: titleField.text, date: current)
//  }
//
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if lunarDateForm.becomeFirstResponder() {
      return true
    } else {
      return titleField.resignFirstResponder()
    }
  }
//
//  @objc func endUpdateDate() {
//    current = datePicker.date
//    validate(text: titleField.text, date: current)
//    resignDateFields()
//  }
//
//  @objc func cancelUpdateDate() {
//    resignDateFields()
//  }
//
//  func resignDateFields() {
//    yearField.resignFirstResponder()
//    monthField.resignFirstResponder()
//    dayField.resignFirstResponder()
//  }
//
//  func validate(text currentText: String?, date: Date) {
//    switch mode {
//    case .new:
//      let enable = currentText?.isEmpty == false
//      enableButton(button: createButton, enable: enable)
//    case .edit(let event):
//      let enable = currentText?.isEmpty == false
//        && (date != event.date || currentText != event.title)
//      enableButton(button: editButton, enable: enable)
//    }
//  }
//
//  func enableButton(button: UIButton, enable: Bool) {
//    if enable {
//      let color = UIColor(named: "title")
//      button.isEnabled = true
//      button.setTitleColor(color, for: .normal)
//      button.layer.borderColor = color?.cgColor
//    } else {
//      let color = UIColor(named: "title_disable")
//      button.isEnabled = false
//      button.setTitleColor(color, for: .normal)
//      button.layer.borderColor = color?.cgColor
//    }
//  }
//
//  func deleteEvent() {
//    guard case let .edit(event) = mode else { return }
//    guard let id = event.id else { return }
//    eventUseCase?.delete(id)
//    didEditFinish?()
////    analytics.log(.event_delete)
////    navigator?.pop(isModal: true)
//  }
//
//  func showDeleteAlert() {
//    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
//      self.deleteEvent()
//    }
//    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
//    let alert = UIAlertController(title: "일정 삭제", message: "진짜 지울꺼예요?ㅠ", preferredStyle: .alert)
//    alert.addAction(deleteAction)
//    alert.addAction(cancelAction)
//    DispatchQueue.main.async {
//      self.present(alert, animated: true)
//    }
//  }
}

extension EventEditViewController {
  class DismissView: BaseView {
    private var imageView: UIImageView!

    override func setupViews() {
      imageView = UIImageView()
      imageView.image = "ic_bottom_dismiss".uiImage
      backgroundColor = .clear
      addSubview(imageView)
    }

    override func setupConstraints() {
      imageView.snp.makeConstraints {
        $0.top.bottom.centerX.equalToSuperview()
      }
    }
  }

  class DateFormView: BaseView, UITextFieldDelegate {
    private let yearLength = 4
    private let monthLength = 2
    private let dayLength = 2

    private var stackView: UIStackView!
    private var yearTextField: UITextField!
    private var ymDivider: UILabel!
    private var monthTextField: UITextField!
    private var mdDivider: UILabel!
    private var dayTextField: UITextField!

    var short: Bool
    var editable: Bool
    var calendar: Calendar
    var year: Int?
    var month: Int?
    var day: Int?
    var completion: ((Int, Int) -> Void)?
    init(short: Bool, editable: Bool, calendar: Calendar, year: Int?, month: Int?, day: Int?) {
      self.short = short
      self.editable = editable
      self.calendar = calendar
      self.year = year
      self.month = month
      self.day = day
      super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func becomeFirstResponder() -> Bool {
      if !short && yearTextField.text?.count ?? 0 < yearLength {
        return yearTextField.becomeFirstResponder()
      } else if monthTextField.text?.count ?? 0 < monthLength {
        return monthTextField.becomeFirstResponder()
      } else if dayTextField.text?.count ?? 0 < dayLength {
        return dayTextField.becomeFirstResponder()
      }
      return false
    }

    override func setupViews() {
      stackView = UIStackView().apply {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 4
        addSubview($0)
      }

      if !short {
        yearTextField = UITextField().apply {
          $0.placeholder = "YYYY"
          $0.font = .preferredFont(.medium, size: 14)
          $0.textColor = editable ? .ee_date_editable : .ee_date_disable
          $0.isEnabled = editable
          $0.keyboardType = .numberPad
          $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
          $0.delegate = self
          if let year {
            $0.text = "\(year)"
          }
          stackView.addArrangedSubview($0)
        }

        ymDivider = UILabel().apply {
          $0.text = "/"
          $0.textColor = .ee_date_slash
          $0.font = .preferredFont(.bold, size: 14)
          stackView.addArrangedSubview($0)
        }
      }

      monthTextField = UITextField().apply {
        $0.placeholder = "MM"
        $0.font = .preferredFont(.medium, size: 14)
        $0.textColor = editable ? .ee_date_editable : .ee_date_disable
        $0.isEnabled = editable
        $0.keyboardType = .numberPad
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        $0.delegate = self
        if let month {
          $0.text = "\(month)".leftPadding(toLength: monthLength, withPad: "0")
        }
        stackView.addArrangedSubview($0)
      }

      mdDivider = UILabel().apply {
        $0.text = "/"
        $0.textColor = .ee_date_slash
        $0.font = .preferredFont(.bold, size: 14)
        stackView.addArrangedSubview($0)
      }

      dayTextField = UITextField().apply {
        $0.placeholder = "dd"
        $0.font = .preferredFont(.medium, size: 14)
        $0.textColor = editable ? .ee_date_editable : .ee_date_disable
        $0.isEnabled = editable
        $0.keyboardType = .numberPad
        $0.delegate = self
        $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        if let day {
          $0.text = "\(day)".leftPadding(toLength: dayLength, withPad: "0")
        }
        stackView.addArrangedSubview($0)
      }
    }

    override func setupConstraints() {
      stackView.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }

    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      textField.resignFirstResponder()
      return true
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
      guard let text = textField.text else { return }

      if textField == yearTextField {
        if text.count >= yearLength {
          monthTextField.becomeFirstResponder()
          ymDivider.textColor = .ee_date_editable
          cutOverflowedText(textField: textField, length: yearLength)
        }
      } else if textField == monthTextField {
        if text.count >= monthLength {
          dayTextField.becomeFirstResponder()
          mdDivider.textColor = .ee_date_editable
          cutOverflowedText(textField: textField, length: monthLength)
        }
      } else if textField == dayTextField {
        if text.count >= dayLength {
          dayTextField.resignFirstResponder()
          cutOverflowedText(textField: textField, length: dayLength)
        }
      }

      if editable,
         let month = monthTextField.text,
         let day = dayTextField.text,
         verifyDate(month: month, day: day) {
        completion?(Int(month)!, Int(day)!)
      }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      guard let text = textField.text else { return false }

      if textField == yearTextField {
        if text.count >= yearLength && range.length == 0 && range.location < yearLength {
          return false
        }
      } else if textField == monthTextField {
        if text.count >= monthLength && range.length == 0 && range.location < monthLength {
          return false
        }
      } else if textField == dayTextField {
        if text.count >= dayLength && range.length == 0 && range.location < dayLength {
          return false
        }
      }
      return true
    }

    func cutOverflowedText(textField: UITextField, length: Int) {
      guard let text = textField.text else { return }
      if text.count > length {
        let index = text.index(text.startIndex, offsetBy: length)
        let newString = text[text.startIndex..<index]
        textField.text = String(newString)
      }
    }

    func verifyDate(month ms: String?, day ds: String?) -> Bool {
      guard
        let ms, ms.count == monthLength,
        let m = Int(ms),
        let ds, ds.count == dayLength,
        let d = Int(ds)
      else { return false }

      let dateComps = DateComponents(
        calendar: .current,
        year: Date.currentYear,
        month: m,
        day: d
      )
      return dateComps.isValidDate
    }

    func updateDate(year: Int?, month: Int?, day: Int?) {
      if let year {
        yearTextField.text = "\(year)"
      }
      if let month {
        monthTextField.text = "\(month)".leftPadding(toLength: monthLength, withPad: "0")
      }
      if let day {
        dayTextField.text = "\(day)".leftPadding(toLength: dayLength, withPad: "0")
      }
    }
  }
}
