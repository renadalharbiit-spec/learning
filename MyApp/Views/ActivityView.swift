import SwiftUI

struct ActivityView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @State private var showGoalEditor = false
    @State private var showCalendar = false
    private let weekLetters = ["S", "M", "T", "W", "T", "F", "S"]

    private let circleSize: CGFloat = 272
    private let freezeHeight: CGFloat = 46
    private let dayCircleSize: CGFloat = 44
    private let headerButtonSize: CGFloat = 44
    private let cardRadius: CGFloat = 28

    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.top, 8)
                .padding(.bottom, 20)
            weekStrip
                .padding(.bottom, 12)
            statsCards

            if viewModel.isGoalEnded {
                Spacer()
                goalStateView(
                    icon: viewModel.isGoalSuccessful ? "clap" : "x",
                    title: viewModel.isGoalSuccessful ? "Well done!" : "You didn't reach your goal this time.",
                    subtitle: viewModel.isGoalSuccessful ? "Ready for your next goal?" : "Want to set another goal?",
                    buttonIcon: "pencil.and.outline"
                )
                Spacer()
            } else {
                Spacer()
                logButton
                Spacer()
                freezeButton
                    .padding(.bottom, 18)
                Text(viewModel.selectedDayMessage ?? viewModel.freezesUsedText)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 40)
        .onAppear { viewModel.checkStreakReset() }
        .fullScreenCover(isPresented: $showGoalEditor) {
            NewGoalView(currentGoal: viewModel.goal) { newGoal in
                viewModel.updateGoal(newGoal)
            }
        }
        .fullScreenCover(isPresented: $showCalendar) {
            CalendarView(goal: viewModel.goal, logs: viewModel.logs)
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Activity")
                    .font(.largeTitle.bold())
                Text(viewModel.todayText)
                    .font(.body)
                    .foregroundStyle(.gray)
            }
            Spacer()
            HStack(spacing: 12) {
                headerButton("calendar") { showCalendar = true }
                headerButton("pencil.and.outline") { showGoalEditor = true }
            }
        }
        .foregroundStyle(.white)
    }

    private func headerButton(_ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(.white)
                .frame(width: headerButtonSize, height: headerButtonSize)
                .appGlass(in: Circle())
        }
    }

    private var weekStrip: some View {
        HStack(spacing: 0) {
            ForEach(Array(viewModel.weekDays.enumerated()), id: \.offset) { index, date in
                Button {
                    viewModel.select(date)
                } label: {
                    VStack(spacing: 6) {
                        Text(weekLetters[index])
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.white)
                        Text(viewModel.dayNumber(date))
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(numberColor(for: date))
                            .frame(width: dayCircleSize, height: dayCircleSize)
                            .background(circleColor(for: date), in: Circle())
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func circleColor(for date: Date) -> Color {
        switch viewModel.status(on: date) {
        case .learned: return .appOrangeDark
        case .freezed: return .appBlueDark
        case nil: return viewModel.isToday(date) ? .appOrange : .clear
        }
    }

    private func numberColor(for date: Date) -> Color {
        switch viewModel.status(on: date) {
        case .learned: return .appOrange
        case .freezed: return .appBlue
        case nil: return .white
        }
    }

    private var statsCards: some View {
        HStack(spacing: 12) {
            statCard(icon: "fire", text: viewModel.streakText, subtitle: "Learned")
            statCard(icon: "snow", text: viewModel.freezedText, subtitle: "Freezed")
        }
    }

    private func statCard(icon: String, text: String, subtitle: String) -> some View {
        VStack(spacing: 8) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(text)
                .font(.headline)
            Text(subtitle)
                .font(.system(size: 13))
                .foregroundStyle(.gray)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .appGlass(in: RoundedRectangle(cornerRadius: cardRadius), interactive: false)
    }

    private var logButton: some View {
        Button {
            viewModel.logLearned()
        } label: {
            Text(viewModel.canLearn ? "Log as Learned" : "Logged as Learned")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(viewModel.canLearn ? Color.white : Color.gray)
                .frame(width: circleSize, height: circleSize)
                .appGlass(
                    in: Circle(),
                    tint: viewModel.canLearn ? Color.appOrange : nil,
                    interactive: viewModel.canLearn
                )
        }
        .disabled(!viewModel.canLearn)
    }

    private var freezeButton: some View {
        Button {
            viewModel.freezeDay()
        } label: {
            Text(viewModel.canFreeze ? "Freeze for a day" : "Freezed for a day")
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(viewModel.canFreeze ? Color.white : Color.gray)
                .frame(width: circleSize, height: freezeHeight)
                .appGlass(
                    in: Capsule(),
                    tint: viewModel.canFreeze ? Color.appBlue : nil,
                    interactive: viewModel.canFreeze
                )
        }
        .disabled(!viewModel.canFreeze)
    }

    private func goalStateView(icon: String, title: String, subtitle: String, buttonIcon: String) -> some View {
        VStack(spacing: 20) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 52)

            VStack(spacing: 6) {
                Text(title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }

            Button {
                showGoalEditor = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: buttonIcon)
                    Text("Set a goal")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .padding(.horizontal, 36)
                .padding(.vertical, 14)
                .appGlass(in: Capsule(), tint: Color.appOrange)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ActivityView(viewModel: ActivityViewModel())
        .preferredColorScheme(.dark)
}
