import Foundation

enum DayStatus {
    case learned
    case freezed
}

struct DayLog {
    let date: Date
    var status: DayStatus
}


