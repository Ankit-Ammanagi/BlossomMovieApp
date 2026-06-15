//
//  ViewModel.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 14/06/26.
//

import Foundation

@Observable class ViewModel {
    enum FetchStatus {
        case success
        case notStarted
        case fetching
        case failed(underlyingError: Error)
    }
    
    private(set) var homeStatus: FetchStatus = .notStarted
    private let dataFetcher = DataFetcher()
    var trendingMovies: [Title] = []
    var trendingTVShows: [Title] = []
    var topRatedMovies: [Title] = []
    var topRatedTVShows: [Title] = []
    
    func getTitles() async {
        homeStatus = .fetching
        
        if trendingMovies.isEmpty {
            do {
                async let tMovies = dataFetcher.fetchTitles(for: "movie", by: "trending")
                async let tTVShows = dataFetcher.fetchTitles(for: "tv", by: "trending")
                async let trMovies = dataFetcher.fetchTitles(for: "movie", by: "top_rated")
                async let trTVShows = dataFetcher.fetchTitles(for: "tv", by: "top_rated")
                
                trendingMovies = try await tMovies
                trendingTVShows = try await tTVShows
                topRatedMovies = try await trMovies
                topRatedTVShows = try await trTVShows
                
                homeStatus = .success
            } catch {
                print(error)
                homeStatus = .failed(underlyingError: error)
            }
        } else {
            homeStatus = .success
        }
    }
}
