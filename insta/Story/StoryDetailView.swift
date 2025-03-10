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

    init(viewModel: StoryDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            AsyncImage(url: viewModel.randomImageURL) { image in
                image.resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } placeholder: {
                ProgressView()
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding()
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 20)
                }

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.toggleLike()
                    }) {
                        Image(systemName: viewModel.story.isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                            .padding(15)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 30)
                    .padding(.trailing, 20)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}
