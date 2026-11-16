import SwiftUI

struct CalendarView: View {
    private let viewModel: CalendarViewModel
    @Environment(\.dismiss) private var dismiss
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    init(goal: LearningGoal, logs: [DayLog]) {
        viewModel = CalendarViewModel(goal: goal, logs: logs)
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(viewModel.months.enumerated()), id: \.element) { index, month in
                        monthSection(month, showDivider: index > 0)
                    }
                }
            }
        }
    }

    // MARK: - الشريط العلوي
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
        }
        .overlay {
            Text("Activities")
                .font(.headline)
        }
    }

    // MARK: - الشهر
    private func monthSection(_ month: Date, showDivider: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if showDivider {
                Divider()
            }

            Text(viewModel.title(for: month))
                .font(.headline)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.weekdayHeaders, id: \.self) { header in
                    Text(header)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.gray)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)

            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(Array(viewModel.cells(for: month).enumerated()), id: \.offset) { _, date in
                    dayCell(date)
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 12)
        }
    }

    // MARK: - خلية اليوم
    @ViewBuilder
    private func dayCell(_ date: Date?) -> some View {
        if let date = date {
            DayCircle(
                number: viewModel.dayNumber(date),
                status: viewModel.status(on: date),
                isToday: viewModel.isToday(date)
            )
        } else {
            Color.clear.frame(width: 40, height: 40)
        }
    }
}

#Preview {
    let calendar = Calendar(identifier: .gregorian)
    let start = calendar.date(byAdding: .day, value: -20, to: Date()) ?? Date()

    var logs: [DayLog] = []
    for offset in 1..<20 {
        if let date = calendar.date(byAdding: .day, value: -offset, to: Date()) {
            logs.append(DayLog(date: date, status: offset % 7 == 3 ? .freezed : .learned))
        }
    }

    return CalendarView(
        goal: LearningGoal(topic: "Swift", duration: .month, startDate: start),
        logs: logs
    )
    .preferredColorScheme(.dark)
}
