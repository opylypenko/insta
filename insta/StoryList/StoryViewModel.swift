//
//  StoryViewModel.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

class StoryViewModel: ObservableObject {
    @Published var stories: [StoryModel] = []
    @Published var isFetching: Bool = false
    @Published var selectedStory: StoryModel? = nil

    private let storyService: StoryServiceProtocol
    let storyStorage: StoryStorage

    init(storyService: StoryServiceProtocol = MockStoryService(), storyStorage: StoryStorage) {
        self.storyService = storyService
        self.storyStorage = storyStorage
        loadNextPage()
    }

    func loadNextPage() {
        guard !isFetching else { return }
        isFetching = true

        storyService.fetchStories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stories):
                    let newStories = stories.map { networkStory in
                        StoryModel(id: UUID(), name: networkStory.username, userAvatar: networkStory.profilePictureUrl)
                    }
                    self?.storyStorage.addStories(newStories)
                    self?.stories = self?.storyStorage.allStories() ?? []
                    self?.isFetching = false
                case .failure(let error):
                    self?.isFetching = false
                    print("Failed to fetch stories: \(error)")
                }
            }
        }
    }

    func selectStory(_ story: StoryModel) {
        selectedStory = story
        markStoryAsViewed(story)
    }

    func markStoryAsViewed(_ story: StoryModel) {
        storyStorage.markStoryAsViewed(story.id)
        stories = storyStorage.allStories()
    }
}
