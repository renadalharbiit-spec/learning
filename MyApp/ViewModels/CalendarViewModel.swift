import SwiftUI
import Combine

class CalendarViewModel: ObservableObject {
    private let logs: [DayLog]

    private let calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.firstWeekday = 1
        return c
    }()

    init(logs: [DayLog]) {
        self.logs = logs
    }

    func status(on date: Date) -> DayStatus? {
        logs.last { calendar.isDate($0.date, inSameDayAs: date) }?.status
    }

    func status(on components: DateComponents) -> DayStatus? {
        guard let date = calendar.date(from: components) else { return nil }
        return status(on: date)
    }
}
