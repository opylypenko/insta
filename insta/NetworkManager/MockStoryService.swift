//
//  MockStoryService.swift
//  insta
//
//  Created by Oleksandr Pylypenko on 10.03.2025.
//

import Foundation

class MockStoryService: StoryServiceProtocol {
    private var allPages: [StoryPage] = []
    private var isDataLoaded = false
    private var currentPageIndex = 0
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        if let url = Bundle.main.url(forResource: "user", withExtension: "json"),
           let jsonData = try? Data(contentsOf: url) {
            do {
                let decodedResponse = try JSONDecoder().decode(StoryResponse.self, from: jsonData)
                allPages = decodedResponse.pages
                isDataLoaded = true
            } catch {
                print("Failed to decode mock data: \(error)")
            }
        }
    }
    
    func fetchStories(completion: @escaping (Result<[NetworkStory], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 3.0) {
            guard self.isDataLoaded, !self.allPages.isEmpty else {
                completion(.failure(NSError(domain: "MockStoryService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data available"])))
                return
            }
            
            let page = self.allPages[self.currentPageIndex]
            self.currentPageIndex = (self.currentPageIndex + 1) % self.allPages.count
            completion(.success(page.users))
        }
    }

}
