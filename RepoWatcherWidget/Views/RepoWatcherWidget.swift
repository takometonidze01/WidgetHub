//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Tako Metonidze on 2/23/25.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> RepoEntry {
        RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                var repo: Repository = try await NetworkManager().get(url: RepoURL.swiftAlgorithms)
                let avatarImageData = await NetworkManager().downloadImageData(from: repo.owner.avatarUrl)
                repo.avatarData = avatarImageData ?? Data()
                //Get Bottom repo if in large widget
                var bottomRepo: Repository?
                if context.family == .systemLarge {
                    bottomRepo = try await NetworkManager().get(url: RepoURL.google)
                    let avatarImageData = await NetworkManager().downloadImageData(from: bottomRepo?.owner.avatarUrl ?? "")
                    bottomRepo?.avatarData = avatarImageData ?? Data()
                }
                
                //Create entry $ timeline
                let entry = RepoEntry(date: .now, repo: repo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct RepoWatcherWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: RepoEntry

    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
        case .systemLarge:
            VStack(spacing: 50) {
                RepoMediumView(repo: entry.repo)
                if let bottomRepo = entry.bottomRepo {
                    RepoMediumView(repo: bottomRepo)
                }
            }
        case .systemExtraLarge, .systemSmall, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct RepoWatcherWidget: Widget {
    let kind: String = "RepoWatcherWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                RepoWatcherWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                RepoWatcherWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Repo Watcher")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

#Preview(as: .systemLarge) {
    RepoWatcherWidget()
} timeline: {
    RepoEntry(date: .now, repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
}
