//
//  RealmEvent.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class RealmEvent: Object {
  dynamic var id: String = UUID().uuidString
  dynamic var title: String = ""
  dynamic var date: Date = Date()

  override static func primaryKey() -> String {
    return "id"
  }
}
