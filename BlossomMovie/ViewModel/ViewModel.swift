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
    private(set) var videoIdStatus: FetchStatus = .notStarted
    
    private let dataFetcher = DataFetcher()
    
    @ObservationIgnored var trendingMovies: [Title] = []
    @ObservationIgnored var trendingTVShows: [Title] = []
    @ObservationIgnored var topRatedMovies: [Title] = []
    @ObservationIgnored var topRatedTVShows: [Title] = []
    @ObservationIgnored var heroTitle: Title = Title.previewTitles[0]
    @ObservationIgnored var videoId: String = ""
    
    func getTitles() async {
        homeStatus = .fetching
        
        if trendingMovies.isEmpty || trendingTVShows.isEmpty || topRatedMovies.isEmpty || topRatedTVShows.isEmpty {
            do {
                async let tMovies = dataFetcher.fetchTitles(for: "movie", by: "trending")
                async let tTVShows = dataFetcher.fetchTitles(for: "tv", by: "trending")
                async let trMovies = dataFetcher.fetchTitles(for: "movie", by: "top_rated")
                async let trTVShows = dataFetcher.fetchTitles(for: "tv", by: "top_rated")
                
                trendingMovies = try await tMovies
                trendingTVShows = try await tTVShows
                topRatedMovies = try await trMovies
                topRatedTVShows = try await trTVShows
                
                if let title = trendingMovies.randomElement() {
                    heroTitle = title
                }
                
                homeStatus = .success
            } catch {
                print(error)
                homeStatus = .failed(underlyingError: error)
            }
        } else {
            homeStatus = .success
        }
    }
    
    func getVideoId(for title: String) async {
        videoIdStatus = .fetching
        
        do {
            videoId = try await dataFetcher.fetchVideoId(for: title)
            videoIdStatus = .success
        } catch {
            print(error)
            videoIdStatus = .failed(underlyingError: error)
        }
    }
}
