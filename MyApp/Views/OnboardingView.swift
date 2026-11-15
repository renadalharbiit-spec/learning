import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = LearningGoalViewModel()
    var onStart: (LearningGoal) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            Image("fire")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 6) {
                Text("Hello Learner")
                    .font(.largeTitle.bold())
                Text("This app will help you learn everyday!")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text("I want to learn")
                TextField("Swift", text: $viewModel.topic)
                Divider()
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("I want to learn it in a")
                DurationPicker(selection: $viewModel.duration)
            }

            Spacer()

            VStack(spacing: 8) {
                Button {
                    onStart(viewModel.makeGoal())
                } label: {
                    Text("Start Learning")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(
                            viewModel.isValid ? Color.appOrange : Color.appOrange.opacity(0.3),
                            in: Capsule()
                        )
                }
                .disabled(!viewModel.isValid)

                Text("You can edit your desire later")
                    .font(.caption2)
                    .foregroundStyle(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(24)
        .foregroundStyle(.white)
    }
}

#Preview {
    OnboardingView { _ in }
        .preferredColorScheme(.dark)
}
