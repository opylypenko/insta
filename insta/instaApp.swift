//
//  instaApp.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import SwiftUI

@main
struct instaApp: App {
    private let storyComposer = StoryComposer()

    var body: some Scene {
        WindowGroup {
            storyComposer.composeMainView()
        }
    }
}
