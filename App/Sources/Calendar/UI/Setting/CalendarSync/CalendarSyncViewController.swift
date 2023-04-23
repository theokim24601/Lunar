//
//  CalendarSyncViewController.swift
//  Lunar
//
//  Created by hbkim on 2023/02/11.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit
import TheodoreCore
import TheodoreUI

final class CalendarSyncViewController: BottomSheetView {
  private var contentView: UIStackView!
  var appleCalendarCell: SyncCell!

  var syncUseCase: SyncUseCase
  var providerSettings: [CalendarProviderSetting]

  init(syncUseCase: SyncUseCase) {
    self.syncUseCase = syncUseCase
    let settings = syncUseCase.currentSettings()
    self.providerSettings = settings.providerSettings

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

    for setting in providerSettings {
      SizedView(height: 8).apply {
        contentView.addArrangedSubview($0)
      }

      SyncCell(syncUseCase: syncUseCase, providerSetting: setting).apply {
        contentView.addArrangedSubview($0)
      }
    }

    SizedView(height: 28).apply {
      contentView.addArrangedSubview($0)
    }
  }

  override func setupConstraints() {
    super.setupConstraints()
    contentView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.top.bottom.equalToSuperview()
    }
  }
}

extension CalendarSyncViewController {
  final class SyncCell: BaseView {
    private var stackView: UIStackView!
    private var titleLabel: UILabel!
    private var syncSwitch: UISwitch!

    var syncUseCase: SyncUseCase
    var providerSetting: CalendarProviderSetting
    init(syncUseCase: SyncUseCase, providerSetting: CalendarProviderSetting) {
      self.syncUseCase = syncUseCase
      self.providerSetting = providerSetting
      super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func setupViews() {
      stackView = UIStackView().apply { stackView in
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 8
        addSubview(stackView)

        titleLabel = UILabel().apply {
          $0.font = .preferredFont(.regular, size: 14)
          $0.textColor = .ee_calendarReg
          $0.text = providerSetting.provider.title
          stackView.addArrangedSubview($0)
        }

        syncSwitch = UISwitch().apply {
          $0.onTintColor = .ee_calendarSwitchTint
          $0.isOn = providerSetting.sync
          $0.addTarget(self, action: #selector(syncWasChanged(_:)), for: .valueChanged)
          stackView.addArrangedSubview($0)
        }
      }
    }

    override func setupConstraints() {
      stackView.snp.makeConstraints {
        $0.edges.equalToSuperview()
      }
    }

    @objc func syncWasChanged(_ sendor: Any) {
      Task {
        let isOn = syncSwitch.isOn
        let result = await syncUseCase.updateSyncStatus(provider: providerSetting.provider, sync: isOn)
        switch result {
        case .success:
          Vibration.success.vibrate()
        case .failure(let error):
          Task { @MainActor in
            syncSwitch.isOn = !isOn
          }
          
          switch error {
          case .calendarAccessDeniedOrRestricted:
            showCalendarAccessDeniedOrRestrictedAlert()
          default:
            break
          }
        }
      }
    }

    @MainActor func showCalendarAccessDeniedOrRestrictedAlert() {
      let action = UIAlertAction(title: "확인", style: .default)
      let alert = UIAlertController(title: "권한이 거부되었습니다", message: "'캘린더'에 일정을 동기화하려면 설정-> 개인정보 보호 및 보안 -> 캘린더로 이동하여 'Lunar' 앱에 대한 권한을 활성화해주세요.", preferredStyle: .alert)
      alert.addAction(action)
      let root = UIApplication.keyWindow?.rootViewController
      if let presented = root?.presentedViewController {
        presented.present(alert, animated: true, completion: nil)
      }
      else {
        root?.present(alert, animated: true, completion: nil)
      }
    }
  }
}
