//
//  ContributorWidget.swift
//  RepoWatcherWidgetExtension
//
//  Created by Tako Metonidze on 2/23/25.
//

import WidgetKit
import SwiftUI

struct ContributorProvider: TimelineProvider {
    func placeholder(in context: Context) -> ContributorEntry {
        ContributorEntry(date: Date(), repo: MockData.repoOne)
    }
    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (ContributorEntry) -> Void) {
        let entry = ContributorEntry(date: Date(), repo: MockData.repoOne)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<ContributorEntry>) -> Void) {
        let nextUpdate = Date().addingTimeInterval(43200)
        let url = RepoURL.google

        Task {
            var repo: Repository = try await NetworkManager().get(url: url)
            let repoAvatar = await NetworkManager().downloadImageData(from: repo.owner.avatarUrl)
            repo.avatarData = repoAvatar ?? Data()

            let contributors: [Contributor] = try await NetworkManager().get(url: "\(url)/contributors")
            var topFour = Array(contributors.prefix(4))
            
            for i in topFour.indices {
                let avatarData = await NetworkManager().downloadImageData(from: topFour[i].avatarUrl)
                topFour[i].avatarData = avatarData ?? Data()
            }
            
            repo.contributors = topFour
    
            let entry = ContributorEntry(date: .now, repo: repo)
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }
}

struct ContributorEntryView : View {
    var entry: ContributorEntry

    var body: some View {
        VStack(spacing: 40) {
            RepoMediumView(repo: entry.repo)
            ContributorMediumView(repo: entry.repo)
        }
    }
}


struct ContributorRepoWidget: Widget {
    let kind: String = "ContributorRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ContributorProvider()) { entry in
            if #available(iOS 17.0, *) {
                ContributorEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                ContributorEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Contributors")
        .description("Keep track of a repository's top contributors.")
        .supportedFamilies([.systemLarge])
    }
}

#Preview(as: .systemLarge) {
    ContributorRepoWidget()
} timeline: {
    ContributorEntry(date: .now, repo: MockData.repoOne)
}
