//
//  SyncCell.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

final class SyncCell: UITableViewCell {
  @IBOutlet weak var calendarImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var syncSwitch: UISwitch!
  @IBOutlet weak var readyLabel: UILabel!

  var provider: CalendarProvider? {
    didSet {
      titleLabel.text = provider?.providerType?.title
      syncSwitch.isOn = provider?.sync ?? false
      if provider?.providerType == .google {
        syncSwitch.isHidden = true
        readyLabel.isHidden = false
      }
    }
  }
  var syncHandler: ((CalendarProviderType, Bool, @escaping (Result<Bool, CalendarError>) -> Void) -> Void)?

  @IBAction func syncWasChanged(_ sender: Any) {
    guard let providerType = provider?.providerType else { return }
    let isOn = self.syncSwitch.isOn

    syncHandler?(providerType, isOn) { [weak self] result in
      switch result {
      case .success:
        break
      case .failure(let error):
        DispatchQueue.main.async {
          self?.syncSwitch.isOn = !isOn
        }
        switch error {
        case .calendarAccessDeniedOrRestricted:
          self?.showCalendarAccessDeniedOrRestrictedAlert()
        default:
          break
        }
      }
    }
  }

  func showCalendarAccessDeniedOrRestrictedAlert() {
    let action = UIAlertAction(title: "확인", style: .default)
    let alert = UIAlertController(title: "권한이 거부되었습니다", message: "'캘린더'에 일정을 동기화하려면 설정-> 개인 정보 보호 -> 캘린더로 이동하여 'Lunar' 앱에 대한 권한을 활성화해주세요.", preferredStyle: .alert)
    alert.addAction(action)
    DispatchQueue.main.async {
      let root = UIApplication.shared.keyWindow?.rootViewController
      if let presented = root?.presentedViewController {
          presented.present(alert, animated: true, completion: nil)
      }
      else {
          root?.present(alert, animated: true, completion: nil)
      }
    }
  }
}
