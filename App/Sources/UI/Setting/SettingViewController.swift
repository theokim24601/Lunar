//
//  SettingViewController.swift
//  Lunar
//
//  Created by hbkim on 2023/11/02.
//  Copyright © 2023 theo. All rights reserved.
//

import UIKit

final class SettingViewController: BaseViewController {
//  var navigator: Navigator?

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var closeButton: UIButton!

  var syncUseCase: SyncUseCase?
  var settings: Settings?

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "SyncCell", bundle: Bundle.main), forCellReuseIdentifier: "SyncCell")
//    analytics.log(.setting_view)
    loadSettings()
    if #available(iOS 13, *) {
      closeButton.isHidden = true
    }
  }

  @IBAction func closeWasTapped(_ sender: Any) {
//    navigator?.pop(isModal: true)
  }
}

extension SettingViewController {
  func loadSettings() {
    self.settings = syncUseCase?.currentSettings()
    tableView.reloadData()
  }
}

extension SettingViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return settings?.providers?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "SyncCell") as! SyncCell
    cell.provider = settings?.providers?[indexPath.row]
    cell.syncHandler = syncUseCase?.updateSync
    return cell
  }
}
