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
    
    init(story: StoryModel, mainViewModel: StoryViewModel) {
        self.viewModel = StoryDetailViewModel(story: story, mainViewModel: mainViewModel)
    }
    
    var body: some View {
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
                        .padding()
                }
                .padding(.top, 50)
                .padding(.trailing, 20)
            }
            
            Spacer()
            AsyncImage(url: viewModel.randomImageURL) { image in
                image.resizable().scaledToFill().frame(maxWidth: .infinity, maxHeight: .infinity)
            } placeholder: {
                ProgressView()
            }
            Spacer()
        }
        .background(Color.black.opacity(0.9))
        .edgesIgnoringSafeArea(.all)
    }
}
