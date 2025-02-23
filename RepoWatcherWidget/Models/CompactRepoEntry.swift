//
//  RepoEntry.swift
//  WidgetHub
//
//  Created by Tako Metonidze on 2/23/25.
//

import WidgetKit
import Foundation

struct CompactRepoEntry: TimelineEntry {
    let date: Date
    let repo: Repository
    let bottomRepo: Repository?
}
