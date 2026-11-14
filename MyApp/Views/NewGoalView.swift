import SwiftUI

struct NewGoalView: View {
    @StateObject private var viewModel: LearningGoalViewModel
    @State private var showAlert = false
    @Environment(\.dismiss) private var dismiss
    var onUpdate: (LearningGoal) -> Void

    init(currentGoal: LearningGoal, onUpdate: @escaping (LearningGoal) -> Void) {
        _viewModel = StateObject(wrappedValue: LearningGoalViewModel(goal: currentGoal))
        self.onUpdate = onUpdate
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            topBar

            VStack(alignment: .leading, spacing: 8) {
                Text("I want to learn")
                TextField("Swift", text: $viewModel.topic)
                Divider()
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("I want to learn it in a")
                HStack(spacing: 10) {
                    ForEach(GoalDuration.allCases, id: \.self) { option in
                        Button {
                            viewModel.duration = option
                        } label: {
                            Text(option.rawValue)
                                .padding(.horizontal, 18)
                                .padding(.vertical, 8)
                                .foregroundStyle(viewModel.duration == option ? Color.white : Color.gray)
                                .background(
                                    viewModel.duration == option ? Color.appOrange : Color.appCard,
                                    in: Capsule()
                                )
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(24)
        .foregroundStyle(.white)
        .alert("Update goal", isPresented: $showAlert) {
            Button("Dismiss", role: .cancel) { }
            Button("Update") {
                onUpdate(viewModel.makeGoal())
                dismiss()
            }
        } message: {
            Text("If you update now, your streak will start over.")
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .padding(12)
                    .ringBackground(Color.appCard, in: Circle())
            }

            Spacer()

            Button {
                showAlert = true
            } label: {
                Image(systemName: "checkmark")
                    .padding(12)
                    .background(
                        viewModel.isValid ? Color.appOrange : Color.appOrange.opacity(0.3),
                        in: Circle()
                    )
            }
            .disabled(!viewModel.isValid)
        }
        .overlay {
            Text("Learning Goal")
                .font(.headline)
        }
    }
}

#Preview {
    NewGoalView(currentGoal: LearningGoal(topic: "Swift", duration: .week)) { _ in }
        .preferredColorScheme(.dark)
}
