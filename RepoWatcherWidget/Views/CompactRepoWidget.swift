//
//  RepoWatcherWidget.swift
//  RepoWatcherWidget
//
//  Created by Tako Metonidze on 2/23/25.
//

import WidgetKit
import SwiftUI

struct CompactRepoProvider: TimelineProvider {
    func placeholder(in context: Context) -> CompactRepoEntry {
        CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CompactRepoEntry) -> ()) {
        let entry = CompactRepoEntry(date: Date(), repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
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
                let entry = CompactRepoEntry(date: .now, repo: repo, bottomRepo: bottomRepo)
                let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
                completion(timeline)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct CompactRepoWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    var entry: CompactRepoEntry

    var body: some View {
        switch family {
        case .systemMedium:
            RepoMediumView(repo: entry.repo)
                .containerBackground(for: .widget) { }
        case .systemLarge:
            VStack(spacing: 50) {
                RepoMediumView(repo: entry.repo)
                if let bottomRepo = entry.bottomRepo {
                    RepoMediumView(repo: bottomRepo)
                }
            }
            .containerBackground(for: .widget) { }
        case .systemExtraLarge, .systemSmall, .accessoryCircular, .accessoryRectangular, .accessoryInline:
            EmptyView()
        @unknown default:
            EmptyView()
        }
    }
}

struct CompactRepoWidget: Widget {
    let kind: String = "CompactRepoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CompactRepoProvider()) { entry in
            if #available(iOS 17.0, *) {
                CompactRepoWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                CompactRepoWidgetEntryView(entry: entry)
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
    CompactRepoWidget()
} timeline: {
    CompactRepoEntry(date: .now, repo: MockData.repoOne, bottomRepo: MockData.repoTwo)
}
