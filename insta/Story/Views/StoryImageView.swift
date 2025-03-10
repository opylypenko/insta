//
//  StoryImageView.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import SwiftUI

struct StoryImageView: View {
    let imageURL: URL
    let offsetX: CGFloat

    var body: some View {
        AsyncImage(url: imageURL) { image in
            image.resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .offset(x: offsetX)
        } placeholder: {
            ProgressView()
        }
    }
}
