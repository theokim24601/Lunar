//
//  CalendarError.swift
//  Lunar
//
//  Created by hbkim on 2023/11/23.
//  Copyright © 2023 theo. All rights reserved.
//

enum CalendarError: Error {
  // MARK: - Repository
  case eventIdNotExists

  // MARK: - DataSource
  case eventNotExistsInCalendar
  case eventNotAddedToCalendar
  case eventNotUpdatedToCalendar
  case eventNotRemovedFromCalendar
  case failedToSaveEvent
  case failedToLoadCalendar
  case failedToConvertSolarDate
  case failedToRemoveEvent
  case failedToRemoveCalendar
  case eventAlreadyExistsInCalendar

  case someCalendarPermissionDenied(providers: [CalendarProvider])

  case calendarSyncFailedInLocal
  case calendarAccessDeniedOrRestricted
}
