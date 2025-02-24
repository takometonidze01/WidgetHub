//
//  Contributor.swift
//  WidgetHub
//
//  Created by Tako Metonidze on 2/24/25.
//

import Foundation

struct Contributor: Codable, Identifiable {
    let id = UUID()
    let login: String
    let avatarUrl: String
    let contributions: Int
    var avatarData: Data = Data()
}

extension Contributor {
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
        case login, contributions
    }
}
