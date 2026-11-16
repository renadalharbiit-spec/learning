import SwiftUI

@main
struct MyApp: App {
    @StateObject private var activityVM = ActivityViewModel()
    @State private var hasStarted = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if hasStarted {
                    ActivityView(viewModel: activityVM)
                } else {
                    OnboardingView { goal in
                        activityVM.updateGoal(goal)
                        
                        hasStarted = true
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
