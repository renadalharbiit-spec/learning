import SwiftUI

struct ActivityView: View {
    @ObservedObject var viewModel: ActivityViewModel
    @State private var showGoalEditor = false
    @State private var showCalendar = false
    private let weekLetters = ["S", "M", "T", "W", "T", "F", "S"]
    private let circleSize: CGFloat = 270

    
    var body: some View {
        VStack(spacing: 25) {
            header
            weekStrip
            statsCards
            Spacer()
            logButton
            Spacer()
            freezeButton
            Text(viewModel.selectedDayMessage ?? viewModel.freezesUsedText)
                .font(.callout)
                .foregroundStyle(.gray)
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
        .onAppear { viewModel.checkStreakReset() }
        .fullScreenCover(isPresented: $showGoalEditor) {      // ← تغيّر: كانت sheet
            NewGoalView(currentGoal: viewModel.goal) { newGoal in
                viewModel.updateGoal(newGoal)
            }
        }
        .fullScreenCover(isPresented: $showCalendar) {
            CalendarView(logs: viewModel.logs)
        }
    }

    // الهيدر
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Activity")
                    .font(.largeTitle.bold())
                Text(viewModel.todayText)
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
            Spacer()
            headerButton("calendar") { showCalendar = true }
            headerButton("pencil.circle") { showGoalEditor = true }
        }
        .foregroundStyle(.white)
    }

    private func headerButton(_ icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .ringBackground(Color.appCard, in: Circle())
        }
    }

    // MARK: - شريط الأسبوع
    private var weekStrip: some View {
        HStack {
            ForEach(Array(viewModel.weekDays.enumerated()), id: \.offset) { index, date in
                Button {
                    viewModel.select(date)
                } label: {
                    VStack(spacing: 10) {
                        Text(weekLetters[index])
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.8))
                        Text(viewModel.dayNumber(date))
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(numberColor(for: date))
                            .frame(width: 46, height: 46)
                            .background(circleColor(for: date), in: Circle())
                            .overlay(
                                Circle().stroke(
                                    Color.white,
                                    lineWidth: viewModel.isSelected(date) && !viewModel.isToday(date) ? 2 : 0
                                )
                            )
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

    // MARK: - البطاقتان
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
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 18)
        .ringBackground(Color.appCard, in: RoundedRectangle(cornerRadius: 30))
    }

    // MARK: - زر Log as Learned
    private var logButton: some View {
        Button {
            viewModel.logLearned()
        } label: {
            Text(viewModel.canLearn ? "Log as Learned" : "Logged as Learned")
                .font(.title2.bold())
                .foregroundStyle(viewModel.canLearn ? Color.white : Color.gray)
                .frame(width: circleSize, height: circleSize)
                .background(viewModel.canLearn ? Color.appOrange : Color.appCard, in: Circle())
        }
        .disabled(!viewModel.canLearn)
    }

    // MARK: - زر Freeze
    private var freezeButton: some View {
        Button {
            viewModel.freezeDay()
        } label: {
            Text(viewModel.canFreeze ? "Freeze for a day" : "Freezed for a day")
                .font(.headline)
                .foregroundStyle(viewModel.canFreeze ? Color.white : Color.gray)
                .frame(width: circleSize, height: 56)
                .ringBackground(viewModel.canFreeze ? Color.appBlue : Color.appDisabled, in: Capsule())
        }
        .disabled(!viewModel.canFreeze)
    }
}

#Preview {
    ActivityView(viewModel: ActivityViewModel())
        .preferredColorScheme(.dark)
}
