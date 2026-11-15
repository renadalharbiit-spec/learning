import SwiftUI

@main
struct MyApp: App {
    @StateObject private var activityVM = ActivityViewModel()
    @State private var hasStarted = false
    private let showDemoData = true

    var body: some Scene {
        WindowGroup {
            Group {
                if hasStarted {
                    ActivityView(viewModel: activityVM)
                } else {
                    OnboardingView { goal in
                        activityVM.updateGoal(goal)
                        if showDemoData {
                            activityVM.loadDemoData()
                        }
                        hasStarted = true
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
