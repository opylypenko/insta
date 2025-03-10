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
            if let nextStoryId = viewModel.nextStoryId {
                CachedStoryImageView(storyId: nextStoryId)
                    .id(nextStoryId)
                    .offset(x: UIScreen.main.bounds.width + dragOffset)
            } else if viewModel.isLoadingNextPage {
                HStack {
                    ProgressView()
                        .scaleEffect(2)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .offset(x: UIScreen.main.bounds.width + dragOffset)
                    Spacer()
                }
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
                                    if viewModel.nextStoryId != nil {
                                        dragOffset = -UIScreen.main.bounds.width
                                        viewModel.nextStory()
                                    } else {
                                        dragOffset = -UIScreen.main.bounds.width / 4
                                        viewModel.loadNextPage()
                                    }
                                } else if value.translation.width > 100 {
                                    if viewModel.prevStoryId != nil {
                                        dragOffset = UIScreen.main.bounds.width
                                        viewModel.previousStory()
                                    } else {
                                        dragOffset = 0
                                    }
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
                .onChange(of: viewModel.isLoadingNextPage) {
                    if !viewModel.isLoadingNextPage {
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
