import SwiftUI

struct DurationPicker: View {
    @Binding var selection: GoalDuration

    var body: some View {
        HStack(spacing: 10) {
            ForEach(GoalDuration.allCases, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    Text(option.rawValue)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 8)
                        .foregroundStyle(selection == option ? Color.white : Color.gray)
                        .background(
                            selection == option ? Color.appOrange : Color.appCard,
                            in: Capsule()
                        )
                }
            }
        }
    }
}
