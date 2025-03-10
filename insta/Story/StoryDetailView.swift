//
//  StoryDetailView.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import SwiftUI

struct StoryDetailView: View {
    @ObservedObject var viewModel: StoryDetailViewModel
    @Environment(\.presentationMode) var presentationMode

    @State private var dragOffset: CGFloat = 0

    init(viewModel: StoryDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            if let nextStoryId = viewModel.nextStoryId {
                CachedStoryImageView(storyId: nextStoryId)
                    .id(nextStoryId)
                    .offset(x: UIScreen.main.bounds.width + dragOffset)
            }
            
            if let prevStoryId = viewModel.prevStoryId {
                CachedStoryImageView(storyId: prevStoryId)
                    .id(prevStoryId)
                    .offset(x: -UIScreen.main.bounds.width + dragOffset)
            }
            
            CachedStoryImageView(storyId: viewModel.currentStoryId)
                .id(viewModel.currentStoryId)
                .offset(x: dragOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation.width
                        }
                        .onEnded { value in
                            withAnimation(.easeOut(duration: 0.3)) {
                                if value.translation.width < -100 {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        dragOffset = -UIScreen.main.bounds.width
                                    }
                                    viewModel.nextStory()
                                } else if value.translation.width > 100 {
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        dragOffset = UIScreen.main.bounds.width
                                    }
                                    viewModel.previousStory()
                                } else {
                                    dragOffset = 0
                                }
                            }
                        }
                )
                .onChange(of: viewModel.isTransitioning) {
                    if !viewModel.isTransitioning {
                        withAnimation(.easeOut(duration: 0.3)) {
                            dragOffset = 0
                        }
                    }
                }
            
            VStack {
                CloseButtonView {
                    presentationMode.wrappedValue.dismiss()
                }

                Spacer()

                LikeButtonView(isLiked: viewModel.isLiked) {
                    viewModel.toggleLike()
                }
            }
        }
    }
}
