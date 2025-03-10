//
//  ContentView.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            StoriesView(storyStorage: StoryStorage())
            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
