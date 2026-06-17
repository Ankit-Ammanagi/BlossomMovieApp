//
//  DataFetcher.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 13/06/26.
//

import Foundation

struct DataFetcher {
    let tmdbAPIKey = APIConfig.shared?.tmdbAPIKey
    let tmdbBaseURL = APIConfig.shared?.tmdbBaseURL
    let youtubeAPIKey = APIConfig.shared?.youtubeAPIKey
    let youtubeSearchURL = APIConfig.shared?.youtubeSearchURL
    
    //https://api.themoviedb.org/3/trending/movie/day?api_key=YOUR_API_KEY
    //https://api.themoviedb.org/3/movie/top_rated?api_key=YOUR_API_KEY
    //https://api.themoviedb.org/3/movie/upcoming?api_key=YOUR_API_KEY
    //https://api.themoviedb.org/3/search/movie?api_key=YourKey&query=PulpFiction
    
    func fetchTitles(for media: String, by type: String, with title: String? = nil) async throws -> [Title] {
        let fetchTitlesURL = try buildURL(media: media, type: type, searchQuery: title)
        
        guard let fetchTitlesURL = fetchTitlesURL else {
            throw NetworkError.urlBuildFailed
        }
        
        print(fetchTitlesURL)
        
        var titles = try await fetchAndDecode(url: fetchTitlesURL, type: TMDBAPIObject.self).results
        Constants.addPosterPath(to: &titles)
        
        return titles
    }
    
    //https://www.googleapis.com/youtube/v3/search?q=Breaking%20Bad%20trailer&key=APIKEY
    func fetchVideoId(for title: String) async throws -> String {
        guard let ytAPIKey = youtubeAPIKey,
              let ytSearchURL = youtubeSearchURL else {
                  throw NetworkError.missingConfig
              }
        
        let titleSearch = title + YoutubeURLStrings.space.rawValue + YoutubeURLStrings.trailer.rawValue
        
        guard let searchUrl = URL(string: ytSearchURL)?.appending(queryItems: [
            URLQueryItem(name: YoutubeURLStrings.queryShorten.rawValue, value: titleSearch),
            URLQueryItem(name: YoutubeURLStrings.key.rawValue, value: ytAPIKey)
        ])  else {
            throw NetworkError.urlBuildFailed
        }
                
        return try await fetchAndDecode(url: searchUrl, type: YoutubeSearchResponse.self).items?.first?.id?.videoId ?? ""
    }
    
    private func fetchAndDecode<T: Decodable>(url: URL, type: T.Type) async throws -> T {
        let (data, urlResponse) = try await URLSession.shared.data(from: url)
        
        guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badURLErrorResponse(underlyingError: NSError(
                domain: "DataFetcher",
                code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"]))
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode(type, from: data)
    }
    
    private func buildURL(media: String, type: String, searchQuery: String? = nil) throws -> URL? {
        guard let baseURL = tmdbBaseURL, let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfig
        }
        
        var path: String
        
        if type == "trending" {
            path = "3/\(type)/\(media)/day"
        } else if type == "top_rated" || type == "upcoming" {
            path = "3/\(media)/\(type)"
        } else if type == "search" {
            path = "3/\(type)/\(media)"
        } else {
            throw NetworkError.urlBuildFailed
        }
        
        var queryItems = [
            URLQueryItem(name:"api_key", value: apiKey)
        ]
        
        if let searchQuery = searchQuery {
            queryItems.append(URLQueryItem(name:"query", value: searchQuery))
        }
        
        guard let url = URL(string: baseURL)?
            .appending(path: path)
            .appending(queryItems: queryItems) else {
                throw NetworkError.urlBuildFailed
            }
        
        return url
    }
}
