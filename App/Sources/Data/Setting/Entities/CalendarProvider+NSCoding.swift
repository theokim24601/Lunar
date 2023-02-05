//
//  CalendarProvider+NSCoding.swift
//  Lunar
//
//  Created by hbkim on 2023/11/27.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

extension CalendarProvider: NSCoding {
  func encode(with coder: NSCoder) {
    coder.encode(self.providerType?.rawValue, forKey: "providerType")
    coder.encode(self.sync, forKey: "sync")
  }
}
