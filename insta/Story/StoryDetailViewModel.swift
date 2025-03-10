//
//  StoryDetailViewModel.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

class StoryDetailViewModel: ObservableObject {
    @Published var currentStoryId: UUID
    @Published var nextStoryId: UUID?
    @Published var prevStoryId: UUID?
    @Published var isLiked: Bool
    @Published var isTransitioning: Bool = false
    
    private let storyStorage: StoryStorage
    private let allStories: [StoryModel]
    
    init?(storyId: UUID, storyStorage: StoryStorage) {
        guard let existingStory = storyStorage.getStory(by: storyId) else {
            print("Error: Story with ID \(storyId) not found!")
            return nil
        }
        
        self.storyStorage = storyStorage
        self.allStories = storyStorage.allStories()
        
        self.currentStoryId = existingStory.id
        self.isLiked = existingStory.isLiked
        
        loadAdjacentStories()
        markAsViewed()
    }
    
    func loadAdjacentStories() {
        if let currentIndex = allStories.firstIndex(where: { $0.id == currentStoryId }) {
            nextStoryId = (currentIndex < allStories.count - 1) ? allStories[currentIndex + 1].id : nil
            prevStoryId = (currentIndex > 0) ? allStories[currentIndex - 1].id : nil
        }
    }
    
    func nextStory() {
        guard let nextId = nextStoryId, let nextStory = storyStorage.getStory(by: nextId) else { return }
        
        isTransitioning = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.prevStoryId = self.currentStoryId
                self.currentStoryId = nextId
                self.isLiked = nextStory.isLiked

                let nextIndex = self.allStories.firstIndex(where: { $0.id == nextId }) ?? 0
                self.nextStoryId = nextIndex < self.allStories.count - 1 ? self.allStories[nextIndex + 1].id : nil

                self.markAsViewed()
                self.isTransitioning = false
            }
    }
    
    func previousStory() {
        guard let prevId = prevStoryId, let prevStory = storyStorage.getStory(by: prevId) else { return }
        isTransitioning = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.nextStoryId = self.currentStoryId
            self.currentStoryId = prevId
            self.isLiked = prevStory.isLiked

            let prevIndex = self.allStories.firstIndex(where: { $0.id == prevId }) ?? 0
            self.prevStoryId = prevIndex > 0 ? self.allStories[prevIndex - 1].id : nil

            self.markAsViewed()
            self.isTransitioning = false
        }
    }
    
    func markAsViewed() {
        storyStorage.markStoryAsViewed(currentStoryId)
    }
    
    func toggleLike() {
        isLiked.toggle()
        storyStorage.updateLikeStatus(for: currentStoryId, isLiked: isLiked)
    }
}
