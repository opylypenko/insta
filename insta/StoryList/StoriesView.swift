//
//  StoriesView.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import SwiftUI

struct StoriesView: View {
    @ObservedObject var viewModel: StoryViewModel
    private weak var composer: StoryComposer?
    
    init(composer: StoryComposer, viewModel: StoryViewModel) {
        self.composer = composer
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top) {
                ForEach(viewModel.stories) { story in
                    VStack {
                        AsyncImage(url: story.userAvatar) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(story.isViewed ? Color.gray : Color.red, lineWidth: 3)
                        )
                        .onTapGesture {
                            viewModel.selectStory(story)
                        }
                        Text(story.name)
                            .font(.caption)
                            .frame(width: 70)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .onAppear {
                        if shouldLoadNextPage(story: story) {
                            viewModel.loadNextPage()
                        }
                    }
                }

                if viewModel.isFetching {
                    ProgressView()
                        .frame(width: 70, height: 70)
                }
            }
            .padding(.top, 10)
        }
        .fullScreenCover(item: $viewModel.selectedStory) { selectedStory in
            if let detailView = composer?.composeStoryDetailView(for: selectedStory.id) {
                    detailView
                } else {
                    Text("Error: Story not found").foregroundColor(.red)
                }
        }
    }

    private func shouldLoadNextPage(story: StoryModel) -> Bool {
        guard let lastStory = viewModel.stories.last else { return false }
        return story.id == lastStory.id && !viewModel.isFetching
    }
}

