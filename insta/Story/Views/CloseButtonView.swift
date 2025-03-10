//
//  CloseButtonView.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import SwiftUI

struct CloseButtonView: View {
    let action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(action: action) {
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
    }
}
