

import SwiftUI
import Combine

class LearningGoalViewModel: ObservableObject {
    @Published var topic: String
    @Published var duration: GoalDuration

    init(goal: LearningGoal = LearningGoal(topic: "", duration: .week)) {
        self.topic = goal.topic
        self.duration = goal.duration
    }

    var trimmedTopic: String {
        topic.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isValid: Bool {
        !trimmedTopic.isEmpty
    }

    func makeGoal() -> LearningGoal {
        LearningGoal(topic: trimmedTopic, duration: duration)
    }
}
