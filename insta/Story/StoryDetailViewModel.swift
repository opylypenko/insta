//
//  StoryDetailViewModel.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

class StoryDetailViewModel: ObservableObject {
    @Published var randomImageURL: URL = URL(string: "https://picsum.photos/400/800")!
    private let storyStorage: StoryStorage
    @Published var story: StoryModel

    init?(storyId: UUID, storyStorage: StoryStorage) {
        guard let existingStory = storyStorage.getStory(by: storyId) else {
            print("Error: Story with ID \(storyId) not found!")
            return nil
        }
        
        self.story = existingStory
        self.storyStorage = storyStorage
    }

    func toggleLike() {
        story.isLiked.toggle()
        storyStorage.updateLikeStatus(for: story.id, isLiked: story.isLiked)
    }
}
