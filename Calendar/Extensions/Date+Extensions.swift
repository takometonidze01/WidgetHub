//
//  Date+Extensions.swift
//  WidgetHub
//
//  Created by Tako Metonidze on 2/23/25.
//

import Foundation

extension Date {
    var weekdayDisplayFormat: String {
        self.formatted(.dateTime.weekday(.wide))
    }
    
    var dayDisplayFormat: String {
        self.formatted(.dateTime.day())
    }
}
