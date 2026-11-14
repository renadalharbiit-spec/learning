//
//  CalendarViewModel.swift
//  MyApp
//
//  Created by Renad Sameer Alharbi on 02/06/1448 AH.
//

import SwiftUI
import Combine

class CalendarViewModel: ObservableObject {
    private let logs: [DayLog]

    private let calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.firstWeekday = 1
        return c
    }()

    let weekdayHeaders = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    init(logs: [DayLog]) {
        self.logs = logs
    }

    // MARK: - الأشهر
    var months: [CalendarMonth] {
        let today = Date()
        guard let currentStart = calendar.dateInterval(of: .month, for: today)?.start else { return [] }

        let firstLogDate = logs.map(\.date).min() ?? today
        guard let firstStart = calendar.dateInterval(of: .month, for: firstLogDate)?.start else { return [] }

        var result: [CalendarMonth] = []
        var cursor = firstStart
        while cursor <= currentStart {
            result.append(makeMonth(startingAt: cursor))
            guard let next = calendar.date(byAdding: .month, value: 1, to: cursor) else { break }
            cursor = next
        }
        return result
    }

    // MARK: - حالة اليوم
    func dayNumber(_ date: Date) -> String {
        String(calendar.component(.day, from: date))
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func status(on date: Date) -> DayStatus? {
        logs.last { calendar.isDate($0.date, inSameDayAs: date) }?.status
    }

    // MARK: - بناء الشهر
    private func makeMonth(startingAt start: Date) -> CalendarMonth {
        let dayCount = calendar.range(of: .day, in: .month, for: start)?.count ?? 30
        let weekday = calendar.component(.weekday, from: start)
        let blanks = (weekday - calendar.firstWeekday + 7) % 7

        var cells: [Date?] = Array(repeating: nil, count: blanks)
        for offset in 0..<dayCount {
            cells.append(calendar.date(byAdding: .day, value: offset, to: start))
        }

        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"

        return CalendarMonth(id: start, title: formatter.string(from: start), cells: cells)
    }
}
