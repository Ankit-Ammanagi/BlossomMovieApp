//
//  Constants.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 12/06/26.
//

import Foundation
import SwiftUI

struct Constants {
    static let homeString = "Home"
    static let searchString = "Search"
    static let downloadString = "Download"
    static let upcommingString = "Upcomming"
    
    static let playString = "Play"
    static let trendingMovies = "Trending Movies"
    static let trendingTVString = "Trending TV"
    static let topRatedMovieString = "Top Rated Movies"
    static let topRatedTVString = "Top Rated TV"
    
    static let homeImageIcon = "house"
    static let searchImageIcon = "magnifyingglass"
    static let downloadImageIcon = "arrow.down.to.line"
    static let upcommingImageIcon = "play.circle"
    
    static let testTitleURL = "https://image.tmdb.org/t/p/w500/nnl6OWkyPpuMm595hmAxNW3rZFn.jpg"
    static let testTitleURL2 = "https://image.tmdb.org/t/p/w500/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg"
    static let testTitleURL3 = "https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg"
    
    static let posterBaseURL = "https://image.tmdb.org/t/p/w500"
    
    static func addPosterPath(to titles: inout[Title]) {
        for i in titles.indices {
            if let posterPath = titles[i].posterPath {
                titles[i].posterPath = Constants.posterBaseURL + posterPath
            }
        }
    }
}

enum YoutubeURLStrings: String {
    case trailer = "trailer"
    case space = " "
    case queryShorten = "q"
    case key = "key"
}

extension Text {
    func ghostButton() -> some View {
        self
            .frame(width: 100, height: 50)
            .foregroundStyle(.borderButton)
            .bold()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.buttonText ,lineWidth: 2)
            )
    }
}
