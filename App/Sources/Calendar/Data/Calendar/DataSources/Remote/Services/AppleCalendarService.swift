//
//  AppleCalendarService.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

import EventKit

final class AppleCalendarService: CalendarRemoteDataSource {
  private struct Key {
    static let calendarDefaultTitle = "Lunar"
  }

  private(set) var provider: CalendarProvider = .apple
  private let eventStore: EKEventStore

  init() {
    self.eventStore = EKEventStore()
  }

  func verifyAuthorizationStatus() async -> Bool {
    switch EKEventStore.authorizationStatus(for: .event) {
    case .authorized:
      return true
    case .notDetermined:
      let accessGranted = try? await EKEventStore().requestAccess(to: .event)
      if accessGranted == true {
        return true
      } else {
        return false
      }
    default:
      return false
    }
  }

  func save(event: Event) throws {
    let eventForAdd = try generateEKEvent(event: event)
    if try hasEventAlready(event: eventForAdd) {
      throw CalendarError.eventAlreadyExistsInCalendar
    }

    do {
      try eventStore.save(eventForAdd, span: .thisEvent)
    } catch {
      throw CalendarError.failedToSaveEvent
    }
  }

  func update(old: Event, new: Event) throws {
    try remove(event: old)
    try save(event: new)
  }

  func remove(event: Event) throws {
    let eventForRemove = try generateEKEvent(event: event)
    guard let storedEvent = try findEvent(ekEvent: eventForRemove) else {
      return
    }

    do {
      try eventStore.remove(storedEvent, span: .thisEvent)
    } catch {
      throw CalendarError.failedToRemoveEvent
    }
  }

  func removeAll() throws {
    do {
      try eventStore.removeCalendar(try calendar, commit: true)
    } catch {
      throw CalendarError.failedToRemoveCalendar
    }
  }
}

private extension AppleCalendarService {
  var calendar: EKCalendar {
    get throws {
      let storeCalendars = eventStore.calendars(for: .event)

      for calendar in storeCalendars where calendar.title == Key.calendarDefaultTitle {
        return calendar
      }

      let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
      newCalendar.title = Key.calendarDefaultTitle
      newCalendar.source = eventStore.defaultCalendarForNewEvents?.source

      do {
        try eventStore.saveCalendar(newCalendar, commit: true)
        return newCalendar
      } catch {
        throw CalendarError.failedToLoadCalendar
      }
    }
  }

  /// Generate an event which will be then added to the calendar
  /// - Parameter event
  func generateEKEvent(event: Event) throws -> EKEvent {
    let newEvent = EKEvent(eventStore: eventStore)
    newEvent.calendar = try calendar
    newEvent.title = event.title
    guard let date = CalendarUtil.nearestFutureSolarIncludingToday(month: event.lunarMonth, day: event.lunarDay) else {
      throw CalendarError.failedToConvertSolarDate
    }
    newEvent.startDate = date
    newEvent.endDate = date
    newEvent.isAllDay = true
    return newEvent
  }

  /// Check if the event was already added to the calendar
  /// - Parameter eventForAdd
  func hasEventAlready(event eventForAdd: EKEvent) throws -> Bool {
    let predicate = eventStore.predicateForEvents(
      withStart: eventForAdd.startDate,
      end: eventForAdd.endDate,
      calendars: [try calendar]
    )

    let existingEvents = eventStore.events(matching: predicate)
    let eventAlreadyExists = existingEvents.contains { (event) -> Bool in
      return event.title == eventForAdd.title
      && event.startDate == eventForAdd.startDate
      && event.endDate == eventForAdd.endDate
    }

    return eventAlreadyExists
  }

  func findEvent(ekEvent: EKEvent) throws -> EKEvent? {
    let predicate = eventStore.predicateForEvents(
      withStart: ekEvent.startDate,
      end: ekEvent.endDate,
      calendars: [try calendar]
    )

    let existingEvents = eventStore.events(matching: predicate)
    return existingEvents.first { (event) -> Bool in
      return event.title == ekEvent.title
      && event.startDate == ekEvent.startDate
      && event.endDate == ekEvent.endDate
    }
  }
}
