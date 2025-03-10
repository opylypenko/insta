//
//  StoryModel.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

struct StoryModel: Identifiable, Equatable {
    let id: UUID
    let name: String
    let image: URL
    var isViewed: Bool = false
    var isLiked: Bool = false
}
