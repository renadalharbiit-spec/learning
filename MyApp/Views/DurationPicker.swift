import SwiftUI

struct DurationPicker: View {
    @Binding var selection: GoalDuration

    var body: some View {
        HStack(spacing: 12) {                                      // ← تغيّر: 12 بين الأزرار
            ForEach(GoalDuration.allCases, id: \.self) { option in
                Button {
                    selection = option
                } label: {
                    Text(option.rawValue)
                        .font(.system(size: 20, weight: .medium))  // ← تغيّر: 20 بدل 17
                        .foregroundStyle(selection == option ? Color.white : Color.gray)
                        .padding(.horizontal, 20)                  // ← تغيّر: أزرار أعرض
                        .padding(.vertical, 10)                    // ← تغيّر: أزرار أطول
                        .appGlass(                                 // ← جديد: زجاج
                            in: Capsule(),
                            tint: selection == option ? Color.appOrange : nil
                        )
                }
            }
        }
    }
}
