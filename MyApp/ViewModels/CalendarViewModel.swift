import Foundation

struct CalendarViewModel {
    let goal: LearningGoal
    let logs: [DayLog]

    private let calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.firstWeekday = 1
        return c
    }()

    private let minimumMonths = 12

    let weekdayHeaders = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]

    init(goal: LearningGoal, logs: [DayLog]) {
        self.goal = goal
        self.logs = logs
    }

    var months: [Date] {
        let start = calendar.startOfDay(for: goal.startDate)
        guard
            let firstMonth = calendar.dateInterval(of: .month, for: start)?.start,
            let goalEnd = calendar.date(byAdding: .day, value: goal.duration.totalDays - 1, to: start),
            let lastGoalMonth = calendar.dateInterval(of: .month, for: goalEnd)?.start
        else { return [] }

        let goalMonths = calendar.dateComponents([.month], from: firstMonth, to: lastGoalMonth).month ?? 0
        let count = max(minimumMonths, goalMonths + 1)

        return (0..<count).compactMap { calendar.date(byAdding: .month, value: $0, to: firstMonth) }
    }

    func title(for month: Date) -> String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: month)
    }

    func cells(for month: Date) -> [Date?] {
        guard let range = calendar.range(of: .day, in: .month, for: month) else { return [] }
        let weekday = calendar.component(.weekday, from: month)
        let blanks = (weekday - calendar.firstWeekday + 7) % 7

        var result: [Date?] = Array(repeating: nil, count: blanks)
        for day in range {
            result.append(calendar.date(byAdding: .day, value: day - 1, to: month))
        }
        return result
    }

    func dayNumber(_ date: Date) -> String {
        String(calendar.component(.day, from: date))
    }

    func status(on date: Date) -> DayStatus? {
        logs.last { calendar.isDate($0.date, inSameDayAs: date) }?.status
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
}
