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
        c.firstWeekday = 1 // الأسبوع يبدأ من الأحد، والسبت هو اليوم الأخير
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

    // ← تغيّر: شلنا !hasFreezedOnSelectedDay، فالـ Freeze ما عاد يعطّل زر Learned
    var canLearn: Bool {
        !hasLearnedOnSelectedDay && !isGoalEnded
    }

    // ← تغيّر: شلنا !hasLearnedOnSelectedDay، فالـ Learned ما عاد يعطّل زر Freeze
    var canFreeze: Bool {
        !hasFreezedOnSelectedDay && freezedDays < goal.duration.maxFreezes && !isGoalEnded
    }

    var isGoalEnded: Bool {
        guard let week = calendar.dateInterval(of: .weekOfYear, for: selectedDate) else { return false }
        let lastDayOfWeek = calendar.date(byAdding: .day, value: 6, to: week.start) ?? Date()
        return calendar.isDate(selectedDate, inSameDayAs: lastDayOfWeek)
    }

    var isGoalSuccessful: Bool {
        streakDays > 0
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
        lastActivityDate = nil
        selectedDate = Date()
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
}
