//
//  ContributorMediumView.swift
//  WidgetHub
//
//  Created by Tako Metonidze on 2/24/25.
//

import SwiftUI
import WidgetKit

struct ContributorMediumView: View {
    let repo: Repository

    var body: some View {
        VStack(spacing: 16.0) {
            HStack {
                Text("Top Contributors")
                    .font(.caption).bold()
                    .foregroundColor(.secondary)
                    .widgetAccentable()
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), alignment: .leading, spacing: 20) {
                ForEach(repo.contributors) { contributor in
                    HStack {
                        Image(uiImage: UIImage(data: contributor.avatarData) ?? UIImage(named: "avatar")!)
                            .resizable()
                            .widgetAccentedRenderingMode(.accented)
                            .frame(width: 44, height: 44)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            Text(contributor.login)
                                .font(.caption)
                                .minimumScaleFactor(0.7)
                                .widgetAccentable()
                            Text("\(contributor.contributions)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .widgetAccentable()
                        }
                    }
                }
            }
        }
    }
}
