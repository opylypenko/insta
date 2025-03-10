//
//  StorySessionCache.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//


import SwiftUI

class StorySessionCache {
    static let shared = StorySessionCache()
    
    private var cachedImages: [UUID: UIImage] = [:]

    private init() {}

    func getImage(for storyId: UUID, completion: @escaping (UIImage?) -> Void) {
        if let cachedImage = cachedImages[storyId] {
            completion(cachedImage)
            return
        }

        let randomImageURL = URL(string: "https://picsum.photos/400/800?random=\(storyId.uuidString)")!
        URLSession.shared.dataTask(with: randomImageURL) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                self.cachedImages[storyId] = image
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
