import SwiftUI

@main
struct MyApp: App {
    @StateObject private var activityVM = ActivityViewModel()   // الـ ViewModel الوحيد للتطبيق
    @State private var hasStarted = false                       // هل خلّصت الـ Onboarding؟

    var body: some Scene {
        WindowGroup {
            Group {                                             // ← جديد: يجمع الشاشتين بحاوية وحدة
                if hasStarted {
                    ActivityView(viewModel: activityVM)
                } else {
                    OnboardingView { goal in
                        activityVM.updateGoal(goal)
                        hasStarted = true
                    }
                }
            }
            .preferredColorScheme(.dark)                        // ← جديد: الدارك مود لكل التطبيق من هنا
        }
    }
}
