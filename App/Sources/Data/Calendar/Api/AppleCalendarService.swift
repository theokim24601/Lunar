//
//  AppleCalendarService.swift
//  Lunar
//
//  Created by hbkim on 2023/11/17.
//  Copyright © 2023 theo. All rights reserved.
//

import EventKit

final class AppleCalendarService: CalendarServiceType {

  private struct Key {
    static let calendarTitle = "Lunar"
  }

  private(set) var type: CalendarProviderType = .apple
  private let eventStore: EKEventStore

  init() {
    self.eventStore = EKEventStore()
  }

  func addEvent(_ event: Event, completion: @escaping CalendarServiceResponse) {
    authorization { result in
      switch result {
      case .success:
        self.addEventToCalendar(event: event, completion: completion)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func removeEvent(_ event: Event, completion: @escaping CalendarServiceResponse) {
    authorization { result in
      switch result {
      case .success:
        self.removeEventFromCalendar(event: event, completion: completion)
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func removeAllEvents() {
    do {
      try eventStore.removeCalendar(retrieveCalendar(), commit: true)
    } catch {

    }
  }

  func authorization(completion: @escaping CalendarServiceResponse) {
    let authStatus = getAuthorizationStatus()
    switch authStatus {
    case .authorized:
      completion(.success(true))
    case .notDetermined:
      requestAccess { (accessGranted, error) in
        if accessGranted {
          completion(.success(true))
        } else {
          completion(.failure(.calendarAccessDeniedOrRestricted))
        }
      }
    default:
      completion(.failure(.calendarAccessDeniedOrRestricted))
    }
  }
}

private extension AppleCalendarService {

  func getAuthorizationStatus() -> EKAuthorizationStatus {
    return EKEventStore.authorizationStatus(for: .event)
  }

  func requestAccess(completion: @escaping EKEventStoreRequestAccessCompletionHandler) {
    eventStore.requestAccess(to: .event, completion: completion)
  }

  /// Try to save an event to the calendar
  /// - Parameter event
  /// - Parameter completion
  func addEventToCalendar(event: Event, completion: @escaping CalendarServiceResponse) {
    let eventToAdd = generateEvent(event: event)
    if eventAlreadyExists(event: eventToAdd) {
      completion(.failure(.eventAlreadyExistsInCalendar))
    } else {
      do {
        try eventStore.save(eventToAdd, span: .thisEvent)
        completion(.success(true))
      } catch {
        completion(.failure(.eventNotAddedToCalendar))
      }
    }
  }

  func removeEventFromCalendar(event: Event, completion: @escaping CalendarServiceResponse) {
    let eventToRemove = generateEvent(event: event)
    if let storedEvent = self.storedEvent(ekEvent: eventToRemove) {
      do {
        try eventStore.remove(storedEvent, span: .thisEvent)
        completion(.success(true))
      } catch {
        completion(.failure(.eventRemoveFailed))
      }
    } else {
      completion(.success(false))
    }
  }

  /// Generate an event which will be then added to the calendar
  /// - Parameter event
  func generateEvent(event: Event) -> EKEvent {
    let newEvent = EKEvent(eventStore: eventStore)
    newEvent.calendar = retrieveCalendar()
    newEvent.title = event.title
    newEvent.startDate = event.date
    newEvent.endDate = event.date
    newEvent.isAllDay = true
    return newEvent
  }

  /// Check if the event was already added to the calendar
  /// - Parameter eventToAdd
  func eventAlreadyExists(event eventToAdd: EKEvent) -> Bool {
    let predicate = eventStore.predicateForEvents(
      withStart: eventToAdd.startDate,
      end: eventToAdd.endDate,
      calendars: [retrieveCalendar()]
    )

    let existingEvents = eventStore.events(matching: predicate)
    let eventAlreadyExists = existingEvents.contains { (event) -> Bool in
      return event.title == eventToAdd.title
        && event.startDate == eventToAdd.startDate
        && event.endDate == eventToAdd.endDate
    }

    return eventAlreadyExists
  }

  func storedEvent(ekEvent: EKEvent) -> EKEvent? {
    let predicate = eventStore.predicateForEvents(
      withStart: ekEvent.startDate,
      end: ekEvent.endDate,
      calendars: [retrieveCalendar()]
    )

    let existingEvents = eventStore.events(matching: predicate)
    return existingEvents.first { (event) -> Bool in
      return event.title == ekEvent.title
        && event.startDate == ekEvent.startDate
        && event.endDate == ekEvent.endDate
    }
  }

  func retrieveCalendar() -> EKCalendar {
    let calendars = eventStore.calendars(for: .event)

    for calendar in calendars {
      if calendar.title == Key.calendarTitle {
        return calendar
      }
    }

    let newCalendar = EKCalendar(for: .event, eventStore: eventStore)
    newCalendar.title = Key.calendarTitle
    newCalendar.source = eventStore.defaultCalendarForNewEvents?.source

    do {
      try eventStore.saveCalendar(newCalendar, commit: true)
      return newCalendar
    } catch {
      fatalError("")
    }
  }
}
