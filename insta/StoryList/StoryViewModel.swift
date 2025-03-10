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

    let storyStorage: StoryStorage

    init(storyStorage: StoryStorage) {
        self.storyStorage = storyStorage
        loadNextPage()
    }

    func loadNextPage() {
        guard !isFetching else { return }
        isFetching = true

        storyStorage.loadNextPage { [weak self] in
            guard let self else { return }
            self.isFetching = false
            self.stories = self.storyStorage.allStories()
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
    
    func refreshStories() {
        stories = storyStorage.allStories()
        for index in stories.indices {
            stories[index].isViewed = storyStorage.getStory(by: stories[index].id)?.isViewed ?? false
        }
        objectWillChange.send()
    }
}
