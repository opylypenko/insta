//
//  StoryModel.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

struct StoryModel: Identifiable {
    let id: UUID
    let name: String
    let userAvatar: URL
    var isViewed: Bool = false
    var isLiked: Bool = false
}
