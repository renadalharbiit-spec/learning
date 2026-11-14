import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel: CalendarViewModel
    @Environment(\.dismiss) private var dismiss
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    private let dayCircleSize: CGFloat = 40

    init(logs: [DayLog]) {
        _viewModel = StateObject(wrappedValue: CalendarViewModel(logs: logs))
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(viewModel.months.enumerated()), id: \.element.id) { index, month in
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
                    .ringBackground(Color.appCard, in: Circle())
            }
            Spacer()
        }
        .overlay {
            Text("Activities")
                .font(.headline)
        }
    }

    // MARK: - الشهر
    private func monthSection(_ month: CalendarMonth, showDivider: Bool) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if showDivider {
                Divider()                                  // ← الخط يمتد على كامل العرض مثل Sketch
            }

            VStack(alignment: .leading, spacing: 12) {
                Text(month.title)
                    .font(.headline)

                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(viewModel.weekdayHeaders, id: \.self) { header in
                        Text(header)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.gray)
                    }
                }

                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(Array(month.cells.enumerated()), id: \.offset) { _, date in
                        dayCell(date)
                    }
                }
            }
            .padding(.horizontal, 20)                      // ← الهوامش للمحتوى فقط
            .padding(.vertical, 16)
        }
    }

    // MARK: - خلية اليوم
    @ViewBuilder
    private func dayCell(_ date: Date?) -> some View {
        if let date = date {
            Text(viewModel.dayNumber(date))
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(numberColor(for: date))
                .frame(width: dayCircleSize, height: dayCircleSize)
                .background(circleColor(for: date), in: Circle())
        } else {
            Color.clear.frame(width: dayCircleSize, height: dayCircleSize)
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
}

// MARK: - بيانات تجريبية للـ Preview فقط
private func makeSampleLogs() -> [DayLog] {
    let calendar = Calendar(identifier: .gregorian)
    var logs: [DayLog] = []
    for offset in 0..<75 {
        guard let date = calendar.date(byAdding: .day, value: -offset, to: Date()) else { continue }
        if offset % 9 == 4 {
            logs.append(DayLog(date: date, status: .freezed))
        } else if offset % 5 != 3 {
            logs.append(DayLog(date: date, status: .learned))
        }
    }
    return logs
}

#Preview {
    CalendarView(logs: makeSampleLogs())
        .preferredColorScheme(.dark)
}
