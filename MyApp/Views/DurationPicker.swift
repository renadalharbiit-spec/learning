import SwiftUI

struct DurationPicker: View {
    @Binding var selection: GoalDuration

    var body: some View {
        AppGlassContainer(spacing: 8) {
            HStack(spacing: 12) {
                ForEach(GoalDuration.allCases, id: \.self) { option in
                    Button {
                        selection = option
                    } label: {
                        Text(option.rawValue)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(selection == option ? Color.white : Color.gray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .appGlass(
                                in: Capsule(),
                                tint: selection == option ? Color.appOrange : nil
                            )
                    }
                }
            }
        }
    }
}
