//
//  CalendarProvider+Extensions.swift
//  Lunar
//
//  Created by hbkim on 2023/11/23.
//  Copyright © 2023 theo. All rights reserved.
//

import Foundation

extension CalendarProviderType {
  var title: String {
    switch self {
    case .apple: return "Apple Calendar"
    case .google: return "Google Calendar"
    }
  }
}
