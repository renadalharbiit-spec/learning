import SwiftUI
import UIKit

struct AppleCalendar: UIViewRepresentable {
    let statusProvider: (DateComponents) -> DayStatus?

    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.calendar = Calendar(identifier: .gregorian)
        view.locale = Locale(identifier: "en_US")
        view.tintColor = UIColor(Color.appOrange)
        view.delegate = context.coordinator
        return view
    }

    func updateUIView(_ uiView: UICalendarView, context: Context) {
        context.coordinator.statusProvider = statusProvider
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(statusProvider: statusProvider)
    }

    final class Coordinator: NSObject, UICalendarViewDelegate {
        var statusProvider: (DateComponents) -> DayStatus?

        init(statusProvider: @escaping (DateComponents) -> DayStatus?) {
            self.statusProvider = statusProvider
        }

        func calendarView(
            _ calendarView: UICalendarView,
            decorationFor dateComponents: DateComponents
        ) -> UICalendarView.Decoration? {
            switch statusProvider(dateComponents) {
            case .learned:
                return .default(color: UIColor(Color.appOrange), size: .large)
            case .freezed:
                return .default(color: UIColor(Color.appBlue), size: .large)
            case nil:
                return nil
            }
        }
    }
}
