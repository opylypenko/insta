//
//  NetworkModels.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

struct NetworkStory: Codable {
    let id: Int
    let username: String
    let profilePictureUrl: URL
    
    enum CodingKeys: String, CodingKey {
        case id
        case username = "name"
        case profilePictureUrl = "profile_picture_url"
    }
}

struct StoryPage: Codable {
    let users: [NetworkStory]
}

struct StoryResponse: Codable {
    let pages: [StoryPage]
}
