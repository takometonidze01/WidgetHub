//
//  MockData.swift
//  WidgetHub
//
//  Created by Tako Metonidze on 2/23/25.
//

import Foundation

struct MockData {
    static let repoOne = Repository(
        name: "Repository 1",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 65,
        watchers: 123,
        openIssues: 55,
        pushedAt: "2024-08-09T18:19:30Z",
        contributors: [
            Contributor(login: "Sean Allen", avatarUrl: "", contributions: 42, avatarData: Data()),
            Contributor(login: "Tako Metonidze", avatarUrl: "", contributions: 23, avatarData: Data()),
            Contributor(login: "Michael Jordan", avatarUrl: "", contributions: 11, avatarData: Data()),
            Contributor(login: "LeBron", avatarUrl: "", contributions: 221, avatarData: Data())
        ]
    )
    
    static let repoTwo = Repository(
        name: "Repository 2",
        owner: Owner(avatarUrl: ""),
        hasIssues: false,
        forks: 123,
        watchers: 210,
        openIssues: 120,
        pushedAt: "2025-01-09T18:19:30Z"
    )
}
