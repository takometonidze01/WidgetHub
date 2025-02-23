//
//  MockData.swift
//  WidgetHub
//
//  Created by Tako Metonidze on 2/23/25.
//

import Foundation

struct MockData {
    static let dayOne = DayEntry(date: dateToDisplay(month: 11, day: 4))
    static let dayTwo = DayEntry(date: dateToDisplay(month: 11, day: 5))
    static let dayThree = DayEntry(date: dateToDisplay(month: 11, day: 6))
    static let dayFour = DayEntry(date: dateToDisplay(month: 11, day: 7))
    
    
    static func dateToDisplay(month: Int, day: Int) -> Date {
        let components = DateComponents(
            calendar: Calendar.current,
            year: 2025,
            month: month,
            day: day
        )
        
        guard let date = Calendar.current.date(from: components) else { return Date() }
        
        return date
    }
}
