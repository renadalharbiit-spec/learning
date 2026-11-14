import SwiftUI

extension Color {
    // ينشئ لون من كود Hex مثل "FF9230"
    init(hex: String) {
        let cleaned = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let value = Scanner(string: cleaned).scanUInt64(representation: .hexadecimal) ?? 0

        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255

        self.init(red: red, green: green, blue: blue)
    }
}

extension Color {
    static let appOrange = Color(hex: "FF9230")
    static let appBlue = Color(hex: "3CD3FE")
    static let appOrangeDark = Color.appOrange.opacity(0.2)
    static let appBlueDark = Color.appBlue.opacity(0.2)
    static let appCard = Color(white: 0.11)
    static let appDisabled = Color(white: 0.10)
}
