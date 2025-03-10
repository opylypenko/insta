//
//  CachedStoryImageView.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import SwiftUI

struct CachedStoryImageView: View {
    let storyId: UUID
    @State private var cachedImage: UIImage?

    var body: some View {
        Group {
            if let image = cachedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ProgressView()
                    .onAppear {
                        StorySessionCache.shared.getImage(for: storyId) { image in
                            cachedImage = image
                        }
                    }
            }
        }
    }
}
