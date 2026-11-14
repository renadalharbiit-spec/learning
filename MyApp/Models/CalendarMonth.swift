//
//  CalendarMonth.swift
//  MyApp
//
//  Created by Renad Sameer Alharbi on 02/06/1448 AH.
//

import Foundation

struct CalendarMonth: Identifiable {
    let id: Date
    let title: String
    let cells: [Date?]
}
