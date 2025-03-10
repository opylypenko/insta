//
//  StoryViewModel.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

class StoryViewModel: ObservableObject {
    @Published var isFetching: Bool = false
    @Published var stories: [StoryModel] = []
    @Published var selectedStory: StoryModel? = nil
    private let storyService: StoryServiceProtocol
    
    init(storyService: StoryServiceProtocol = MockStoryService()) {
        self.storyService = storyService
        loadNextPage()
    }
    
    func loadNextPage() {
        guard !isFetching else { return }
        isFetching = true
        storyService.fetchStories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let stories):
                    self?.isFetching = false
                    let newStories = stories.map { networkStory in
                        StoryModel(id: UUID(), name: networkStory.username, image: networkStory.profilePictureUrl)
                    }
                    self?.stories.append(contentsOf: newStories)
                case .failure(let error):
                    self?.isFetching = false
                    print("Failed to fetch stories: \(error)")
                }
            }
        }
    }
    
    func markStoryAsViewed(_ story: StoryModel) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index].isViewed = true
        }
    }
    
    func toggleLike(for story: StoryModel) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index].isLiked.toggle()
        }
    }
}
