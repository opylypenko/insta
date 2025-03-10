//
//  LikeButtonView.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import SwiftUI

struct LikeButtonView: View {
    let isLiked: Bool
    let action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: action) {
                Image(systemName: isLiked ? "heart.fill" : "heart")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.red)
                    .padding(15)
                    .clipShape(Circle())
            }
            .padding(.bottom, 30)
            .padding(.trailing, 20)
        }
    }
}
