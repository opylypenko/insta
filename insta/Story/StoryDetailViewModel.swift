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
    @Published var isLoadingNextPage = false
    
    private let storyStorage: StoryStorage
    
    init?(storyId: UUID, storyStorage: StoryStorage) {
        guard let existingStory = storyStorage.getStory(by: storyId) else {
            print("Error: Story with ID \(storyId) not found!")
            return nil
        }
        
        self.storyStorage = storyStorage
        
        self.currentStoryId = existingStory.id
        self.isLiked = existingStory.isLiked
        
        loadAdjacentStories()
        markAsViewed()
    }
    
    func loadAdjacentStories() {
        let allStories = storyStorage.allStories()
        
        if let currentIndex = allStories.firstIndex(where: { $0.id == currentStoryId }) {
            nextStoryId = (currentIndex < allStories.count - 1) ? allStories[currentIndex + 1].id : nil
            prevStoryId = (currentIndex > 0) ? allStories[currentIndex - 1].id : nil
        }
    }
    
    func nextStory() {
        if nextStoryId == nil {
            loadNextPage()
            return
        }
        
        guard let nextId = nextStoryId, let nextStory = storyStorage.getStory(by: nextId) else { return }
        
        isTransitioning = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.prevStoryId = self.currentStoryId
            self.currentStoryId = nextId
            self.isLiked = nextStory.isLiked
            
            let allStories = self.storyStorage.allStories()
            
            let nextIndex = allStories.firstIndex(where: { $0.id == nextId }) ?? 0
            
            if nextIndex < allStories.count - 1 {
                self.nextStoryId =  allStories[nextIndex + 1].id
            } else {
                self.nextStoryId = nil
                self.loadNextPage()
            }

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

            let allStories = self.storyStorage.allStories()
            
            let prevIndex = allStories.firstIndex(where: { $0.id == prevId }) ?? 0
            self.prevStoryId = prevIndex > 0 ? allStories[prevIndex - 1].id : nil

            self.markAsViewed()
            self.isTransitioning = false
        }
    }
    
    func loadNextPage() {
        guard !isLoadingNextPage else { return }
        isLoadingNextPage = true

        storyStorage.loadNextPage { [weak self] in
            guard let self else { return }
            
            let allStories = self.storyStorage.allStories()
            
            let currentId = allStories.firstIndex(where: { $0.id == self.currentStoryId }) ?? 0
            if currentId + 1 < allStories.count - 1 {
                self.prevStoryId = currentStoryId
                self.currentStoryId = allStories[currentId + 1].id
                
                if currentId + 2 < allStories.count - 1 {
                    self.nextStoryId = allStories[currentId + 2].id
                }
            }
            
            self.isLoadingNextPage = false
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
