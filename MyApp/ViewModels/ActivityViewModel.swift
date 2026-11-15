import SwiftUI
import Combine

class ActivityViewModel: ObservableObject {


    @Published var goal: LearningGoal
    @Published var streakDays = 0
    @Published var freezedDays = 0
    @Published var logs: [DayLog] = []
    @Published var selectedDate = Date()
    private var lastActivityDate: Date?
    private let streakResetHours: Double = 32
    private let calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.firstWeekday = 1                        
        return c
    }()

    
    init(goal: LearningGoal = LearningGoal(topic: "Swift", duration: .week)) {
        self.goal = goal
    }

    var streakText: String {
        "\(streakDays) \(streakDays == 1 ? "day" : "days")"
    }

    var freezedText: String {
        "\(freezedDays) \(freezedDays == 1 ? "day" : "days")"
    }

    var freezesUsedText: String {
        "\(freezedDays) out of \(goal.duration.maxFreezes) Freezes used"
    }

    var hasLearnedOnSelectedDay: Bool { hasLog(.learned, on: selectedDate) }
    var hasFreezedOnSelectedDay: Bool { hasLog(.freezed, on: selectedDate) }

    var canLearn: Bool {
        !hasLearnedOnSelectedDay
    }

    var canFreeze: Bool {
        !hasFreezedOnSelectedDay && freezedDays < goal.duration.maxFreezes
    }


    var todayText: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, d MMMM"
        return formatter.string(from: Date())
    }

    var weekDays: [Date] {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: Date()) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: week.start) }
    }

    func dayNumber(_ date: Date) -> String {
        String(calendar.component(.day, from: date))
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func status(on date: Date) -> DayStatus? {
        logs.last { calendar.isDate($0.date, inSameDayAs: date) }?.status
    }

    func isSelected(_ date: Date) -> Bool {
        calendar.isDate(date, inSameDayAs: selectedDate)
    }

    func select(_ date: Date) {
        selectedDate = date
    }

    var selectedDayMessage: String? {
        if calendar.isDateInToday(selectedDate) { return nil }
        switch status(on: selectedDate) {
        case .learned: return "You learned on this day"
        case .freezed: return "You froze this day"
        case nil: return "No activity on this day"
        }
    }

    func logLearned() {
        checkStreakReset()
        guard canLearn else { return }
        streakDays += 1
        addLog(.learned, on: selectedDate)
    }

    func freezeDay() {
        checkStreakReset()
        guard canFreeze else { return }
        freezedDays += 1
        addLog(.freezed, on: selectedDate)
    }


    func updateGoal(_ newGoal: LearningGoal) {
        goal = newGoal
        streakDays = 0
        freezedDays = 0
        logs = []
        lastActivityDate = nil     //
        selectedDate = Date()      //
    }

    func checkStreakReset() {
        guard let last = lastActivityDate else { return }
        let hoursPassed = Date().timeIntervalSince(last) / 3600
        if hoursPassed > streakResetHours {
            streakDays = 0
            freezedDays = 0
        }
    }

    private func addLog(_ status: DayStatus, on date: Date) {
        logs.append(DayLog(date: date, status: status))
        lastActivityDate = Date()
    }

    private func hasLog(_ status: DayStatus, on date: Date) -> Bool {
        logs.contains { log in
            log.status == status && calendar.isDate(log.date, inSameDayAs: date)
        }
    }
    
    func loadDemoData() {
        guard
            let thisMonth = calendar.dateInterval(of: .month, for: Date())?.start,
            let startDate = calendar.date(byAdding: .month, value: -2, to: thisMonth),
            let totalDays = calendar.dateComponents([.day], from: startDate, to: Date()).day
        else { return }

        var demoLogs: [DayLog] = []

        for daysAgo in 1...totalDays {
            guard let date = calendar.date(byAdding: .day, value: -daysAgo, to: Date()) else { continue }

            if daysAgo % 13 == 5 {
                demoLogs.append(DayLog(date: date, status: .freezed))
            } else if daysAgo % 17 != 9 {
                demoLogs.append(DayLog(date: date, status: .learned))
            }
        }

        logs = demoLogs
    }
}
