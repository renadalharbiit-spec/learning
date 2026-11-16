import SwiftUI

extension View {
    // الستايل القديم (نستخدمه كبديل)
    func ringBackground<S: Shape>(_ fill: Color, in shape: S) -> some View {
        self
            .background(fill, in: shape)
            .overlay(shape.stroke(Color.white.opacity(0.15), lineWidth: 1))
    }

    // Liquid Glass
    @ViewBuilder
    func appGlass<S: Shape>(in shape: S, tint: Color? = nil, interactive: Bool = true) -> some View {
        if #available(iOS 26.0, *) {
            self.glassEffect(.regular.tint(tint).interactive(interactive), in: shape)
        } else {
            self.ringBackground(tint ?? Color.appCard, in: shape)
        }
    }
}
