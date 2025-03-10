//
//  StoryComposer.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import SwiftUI

class StoryComposer {
    private let storyStorage: StoryStorage

    init() {
        self.storyStorage = StoryStorage()
    }

    func composeMainView() -> some View {
        return StoriesView(composer: self, viewModel: StoryViewModel(storyStorage: storyStorage))
    }

    func composeStoryDetailView(for storyId: UUID) -> StoryDetailView? {
        guard let detailViewModel = StoryDetailViewModel(storyId: storyId, storyStorage: storyStorage) else {
            return nil
        }
        return StoryDetailView(viewModel: detailViewModel)
    }
}
