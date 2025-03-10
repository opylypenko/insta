//
//  StoryServiceProtocol.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//


protocol StoryServiceProtocol {
    func fetchStories(completion: @escaping (Result<[NetworkStory], Error>) -> Void)
}
