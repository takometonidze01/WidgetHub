//
//  NetworkManager.swift
//  WidgetHub
//
//  Created by Tako Metonidze on 2/23/25.
//

import Foundation

enum CustomError: Error {
    case unsupportedUrl
}

protocol NetworkManagerProtocol: AnyObject {
    func get<T: Codable>(url: String) async throws -> T
}

final class NetworkManager: NetworkManagerProtocol {
    func get<T: Codable>(url: String) async throws -> T {
        guard let url = URL(string: url) else {
            throw CustomError.unsupportedUrl
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw error
        }
    }
}
