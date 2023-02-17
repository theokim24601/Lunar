//
//  CalendarProvider.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

enum CalendarProvider: String, CaseIterable {
  case apple
//  case google

  var title: String {
    switch self {
    case .apple: return "Apple Calendar"
//    case .google: return "Google Calendar"
    }
  }
}
