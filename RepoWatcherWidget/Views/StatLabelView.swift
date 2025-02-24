//
//  StatLabelView.swift
//  WidgetHub
//
//  Created by Tako Metonidze on 2/23/25.
//

import SwiftUI

struct StatLabel: View {
    let value: Int
    let systemImageName: String
    
    var body: some View {
        Label {
            Text("\(value)")
                .font(.footnote)
                .contentTransition(.numericText())
                .widgetAccentable()
        } icon: {
            Image(systemName: "\(systemImageName)")
                .foregroundColor(.green)
        }
        .fontWeight(.medium)
    }
}
