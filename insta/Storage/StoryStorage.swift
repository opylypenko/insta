//
//  StoryStorage.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

class StoryStorage {
    private var stories: [StoryModel] = []

    func getStory(by id: UUID) -> StoryModel? {
        return stories.first(where: { $0.id == id })
    }

    func updateLikeStatus(for id: UUID, isLiked: Bool) {
        if let index = stories.firstIndex(where: { $0.id == id }) {
            stories[index].isLiked = isLiked
        }
    }

    func markStoryAsViewed(_ id: UUID) {
        if let index = stories.firstIndex(where: { $0.id == id }) {
            stories[index].isViewed = true
        }
    }

    func addStories(_ newStories: [StoryModel]) {
        stories.append(contentsOf: newStories)
    }

    func allStories() -> [StoryModel] {
        return stories
    }
}
