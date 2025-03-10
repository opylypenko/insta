//
//  StoryStorage.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

class StoryStorage {
    private let storyService: StoryServiceProtocol
    private var stories: [StoryModel] = []
    
    init(storyService: StoryServiceProtocol) {
        self.storyService = storyService
    }
    
    
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

    func allStories() -> [StoryModel] {
        return stories
    }
    
    func loadNextPage(competion: @escaping () -> Void) {
        fetchStories(competion: competion)
    }
    
    private func fetchStories(competion: @escaping () -> Void) {
        storyService.fetchStories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stories):
                    let newStories = stories.map { networkStory in
                        StoryModel(
                            id: UUID(),
                            name: networkStory.username,
                            userAvatar: networkStory.profilePictureUrl
                        )
                    }
                    self?.stories.append(contentsOf: newStories)
                    competion()
                case .failure(let error):
                    competion()
                    print("Failed to fetch stories: \(error)")
                }
            }
        }
    }
}
