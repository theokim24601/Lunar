//
//  CalendarError.swift
//  Lunar
//
//  Created by hbkim on 2023/11/23.
//  Copyright © 2023 theo. All rights reserved.
//

enum CalendarError: Error {
  case calendarSyncFailedInLocal
  case calendarRetrieveFailed

  case eventNotExistsInCalendar
  case eventNotAddedToCalendar
  case eventNotRemovedFromCalendar
  case eventRemoveFailed
  case eventAlreadyExistsInCalendar
  case calendarAccessDeniedOrRestricted
}
