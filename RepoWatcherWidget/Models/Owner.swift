//
//  Owner.swift
//  WidgetHub
//
//  Created by Tako Metonidze on 2/23/25.
//

import Foundation

struct Owner: Codable {
    let avatarUrl: String
}

extension Owner {
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
