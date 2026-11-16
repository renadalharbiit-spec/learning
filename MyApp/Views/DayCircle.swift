import SwiftUI

struct DayCircle: View {
    let number: String
    let status: DayStatus?
    let isToday: Bool

    var body: some View {
        Text(number)
            .font(.system(size: 20, weight: .medium))
            .foregroundStyle(numberColor)
            .frame(width: 40, height: 40)
            .background(circleColor, in: Circle())
    }

    private var numberColor: Color {
        switch status {
        case .learned: return .appOrange
        case .freezed: return .appBlue
        case nil: return .white
        }
    }

    private var circleColor: Color {
        switch status {
        case .learned: return .appOrangeDark
        case .freezed: return .appBlueDark
        case nil: return isToday ? .appOrange : .clear
        }
    }
}
