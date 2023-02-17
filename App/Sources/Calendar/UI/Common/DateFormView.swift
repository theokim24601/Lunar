//
//  DateFormView.swift
//  Lunar
//
//  Created by hbkim on 2023/02/15.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

final class DateFormView: BaseView, UITextFieldDelegate {
  private var stackView: UIStackView!
  private var yearTextField: UITextField!
  private var ymDivider: UILabel!
  private var monthTextField: UITextField!
  private var mdDivider: UILabel!
  private var dayTextField: UITextField!

  var short: Bool
  var editable: Bool
  var calendar: Calendar
  var year: String?
  var month: String?
  var day: String?
  var dateChanged: ((String, String) -> Void)?
  init(short: Bool, editable: Bool, calendar: Calendar, year: String?, month: String?, day: String?) {
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
    if !short && yearTextField.text?.count ?? 0 < CalendarUtil.yearLength {
      return yearTextField.becomeFirstResponder()
    } else if monthTextField.text?.count ?? 0 < CalendarUtil.monthLength {
      return monthTextField.becomeFirstResponder()
    } else if dayTextField.text?.count ?? 0 < CalendarUtil.dayLength {
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
        $0.text = year
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
      $0.text = month
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
      $0.text = day
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
      year = text
      if text.count >= CalendarUtil.yearLength {
        monthTextField.becomeFirstResponder()
        ymDivider.textColor = .ee_date_editable
        cutOverflowedText(textField: textField, length: CalendarUtil.yearLength)
      }
    } else if textField == monthTextField {
      month = text
      if text.count >= CalendarUtil.monthLength {
        dayTextField.becomeFirstResponder()
        mdDivider.textColor = .ee_date_editable
        cutOverflowedText(textField: textField, length: CalendarUtil.monthLength)
      }
    } else if textField == dayTextField {
      day = text
      if text.count >= CalendarUtil.dayLength {
        dayTextField.resignFirstResponder()
        cutOverflowedText(textField: textField, length: CalendarUtil.dayLength)
      }
    }

    if editable {
      let month = monthTextField.text ?? ""
      let day = dayTextField.text ?? ""
      dateChanged?(month, day)
    }
  }

  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else { return false }

    if textField == yearTextField {
      if text.count >= CalendarUtil.yearLength && range.length == 0 && range.location < CalendarUtil.yearLength {
        return false
      }
    } else if textField == monthTextField {
      if text.count >= CalendarUtil.monthLength && range.length == 0 && range.location < CalendarUtil.monthLength {
        return false
      }
    } else if textField == dayTextField {
      if text.count >= CalendarUtil.dayLength && range.length == 0 && range.location < CalendarUtil.dayLength {
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

  func updateDate(year: String?, month: String?, day: String?) {
    yearTextField.text = year ?? ""
    monthTextField.text = month ?? ""
    dayTextField.text = day ?? ""
  }
}
