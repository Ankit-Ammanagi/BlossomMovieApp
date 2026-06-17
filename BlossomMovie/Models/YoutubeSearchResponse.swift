//
//  YoutubeSearchResponse.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 16/06/26.
//

import Foundation

struct YoutubeSearchResponse: Codable {
    let items: [YoutubeSearchItem]?
}

struct YoutubeSearchItem: Codable {
    let id: YoutubeSearchItemID?
}

struct YoutubeSearchItemID: Codable {
    let videoId: String?
}
