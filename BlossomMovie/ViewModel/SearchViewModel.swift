//
//  SearchViewModel.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 17/06/26.
//

import Foundation

@Observable class SearchViewModel {
    private(set) var errorMessage: String?
    private(set) var searchResults: [Title] = []
    private let dataFetcher = DataFetcher()
    
    func getSearchResults(by media: String, for title: String) async  {
        do {
            errorMessage = nil
            if searchResults.isEmpty || title.count == 0 {
                searchResults = try await dataFetcher.fetchTitles(for: media, by: "trending")
            } else {
                print("Fetching trending titles for \(title)")
                searchResults = try await dataFetcher.fetchTitles(for: media, by: "search", with: title)
            }
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
}
