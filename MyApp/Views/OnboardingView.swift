import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = LearningGoalViewModel()
    var onStart: (LearningGoal) -> Void

    // MARK: - مقاسات التصميم
    private let sideMargin: CGFloat = 16
    private let flameSize: CGFloat = 40

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {       // ← المسافات نحددها لكل جزء بنفسنا
            flame
                .padding(.top, 56)
            titleBlock
                .padding(.top, 80)
            goalField
                .padding(.top, 34)
            durationSection
                .padding(.top, 29)

            Spacer()

            startButton                                  // ← بدون padding تحت
        }
        .padding(.horizontal, sideMargin)
        .foregroundStyle(.white)
    }

    // MARK: - الشعلة
    private var flame: some View {
        Image("fire")
            .resizable()
            .scaledToFit()
            .frame(width: flameSize, height: flameSize)
            .frame(maxWidth: .infinity)
    }

    // MARK: - العنوان والوصف
    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            (Text("Hello ").fontWeight(.regular) + Text("Learner").fontWeight(.bold))
                .font(.system(size: 38))
            Text("This app will help you learn everyday!")
                .font(.system(size: 18))
                .foregroundStyle(Color.white.opacity(0.75))
        }
    }

    // MARK: - حقل الموضوع
    private var goalField: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("I want to learn")
                .font(.system(size: 18))

            VStack(alignment: .leading, spacing: 12) {
                TextField("Swift", text: $viewModel.topic)
                    .font(.system(size: 20))
                Divider()
            }
        }
    }

    // MARK: - المدة
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 11) {
            Text("I want to learn it in a")
                .font(.system(size: 18))
            DurationPicker(selection: $viewModel.duration)
        }
    }

    // MARK: - زر البداية
    private var startButton: some View {
        VStack(spacing: 10) {
            Button {
                onStart(viewModel.makeGoal())
            } label: {
                Text("Start Learning")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 21)
                    .padding(.vertical, 12)
                    .appGlass(
                        in: Capsule(),
                        tint: viewModel.isValid ? Color.appOrange : Color.appOrange.opacity(0.35),
                        interactive: viewModel.isValid
                    )
            }
            .disabled(!viewModel.isValid)

            Text("You can edit your desire later")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    OnboardingView { _ in }
        .preferredColorScheme(.dark)
}
