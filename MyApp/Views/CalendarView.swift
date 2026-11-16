import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel: CalendarViewModel
    @Environment(\.dismiss) private var dismiss

    init(logs: [DayLog]) {
        _viewModel = StateObject(wrappedValue: CalendarViewModel(logs: logs))
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

            AppleCalendar { components in
                viewModel.status(on: components)
            }
            .padding(.horizontal, 8)

            

            Spacer()
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
                    .ringBackground(Color.appCard, in: Circle())
            }
            Spacer()
        }
        .overlay {
            Text("Activities")
                .font(.headline)
        }
    }

   
    }


//  - بيانات تجريبية  Preview فقط
private func makeSampleLogs() -> [DayLog] {
    let calendar = Calendar(identifier: .gregorian)
    var logs: [DayLog] = []
    for offset in 1..<75 {
        guard let date = calendar.date(byAdding: .day, value: -offset, to: Date()) else { continue }
        if offset % 13 == 5 {
            logs.append(DayLog(date: date, status: .freezed))
        } else if offset % 17 != 9 {
            logs.append(DayLog(date: date, status: .learned))
        }
    }
    return logs
}

#Preview {
    CalendarView(logs: makeSampleLogs())
        .preferredColorScheme(.dark)
}
