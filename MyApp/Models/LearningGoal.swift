import Foundation

enum GoalDuration: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"

    var maxFreezes: Int {
        switch self {
        case .week: return 2
        case .month: return 8
        case .year: return 96
        }
    }

    var totalDays: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .year: return 365
        }
    }
}

struct LearningGoal {
    var topic: String
    var duration: GoalDuration
    var startDate: Date = Date()
}

