//
//  StoryDetailViewModel.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

class StoryDetailViewModel: ObservableObject {
    @Published var randomImageURL: URL = URL(string: "https://picsum.photos/400/800")!
    @Published var selectedStory: StoryModel
    
    private let mainViewModel: StoryViewModel
    
    init(story: StoryModel, mainViewModel: StoryViewModel) {
        self.selectedStory = story
        self.mainViewModel = mainViewModel
    }
}

