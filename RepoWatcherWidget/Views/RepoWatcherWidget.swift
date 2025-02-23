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
        RepoEntry(date: Date(), repo: Repository.placeholder)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (RepoEntry) -> ()) {
        let entry = RepoEntry(date: Date(), repo: Repository.placeholder)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(43200) // 12 hours in seconds
            
            do {
                var repo: Repository = try await NetworkManager().get(url: RepoURL.swiftAlgorithms)
                let avatarImageData = await NetworkManager().downloadImageData(from: repo.owner.avatarUrl)
                let entry = RepoEntry(date: .now, repo: repo)
                repo.avatarData = avatarImageData ?? Data()
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
            VStack(spacing: 36) {
                RepoMediumView(repo: entry.repo)
                RepoMediumView(repo: entry.repo)
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
    RepoEntry(date: .now, repo: Repository.placeholder)
}
