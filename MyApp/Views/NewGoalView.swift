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
                DurationPicker(selection: $viewModel.duration)
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
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .appGlass(in: Circle())
            }

            Spacer()

            Button {
                showAlert = true
            } label: {
                Image(systemName: "checkmark")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(viewModel.isValid ? Color.white : Color.gray)
                    .frame(width: 44, height: 44)
                    .appGlass(
                        in: Circle(),
                        tint: viewModel.isValid ? Color.appOrange : nil,
                        interactive: viewModel.isValid
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
