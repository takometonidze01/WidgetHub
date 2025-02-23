//
//  Repository.swift
//  RepoWatcherWidgetExtension
//
//  Created by Tako Metonidze on 2/23/25.
//

import Foundation

struct Repository: Codable {
    let name: String
    let owner: Owner
    let hasIssues: Bool
    let forks: Int
    let watchers: Int
    let openIssues: Int
    let pushedAt: String
    
    static let placeholder = Repository(
        name: "Your Repo",
        owner: Owner(avatarUrl: ""),
        hasIssues: true,
        forks: 65,
        watchers: 123,
        openIssues: 55,
        pushedAt: "2024-08-09T18:19:30Z"
    )
}

extension Repository {
    enum CodingKeys: String, CodingKey {
        case name, owner, forks, watchers
        case hasIssues = "has_issues"
        case openIssues = "open_issues"
        case pushedAt = "pushed_at"
    }
}

enum RepoURL {
    static let swiftAlgorithms = "https://api.github.com/repos/Apple/swift-algorithms"
    static let publish = "https://api.github.com/repos/johnsundell/publish"
    static let google = "https://api.github.com/repos/google/GoogleSignIn-iOS"
}
