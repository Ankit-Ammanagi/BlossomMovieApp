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
    
    //https://api.themoviedb.org/3/trending/movie/day?api_key=YOUR_API_KEY
    //https://api.themoviedb.org/3/movie/top_rated?api_key=YOUR_API_KEY
    //https://api.themoviedb.org/3/movie/upcoming?api_key=YOUR_API_KEY
    //https://api.themoviedb.org/3/search/movie?api_key=YourKey&query=PulpFiction
    
    func fetchTitles(for media: String, by type: String) async throws -> [Title] {
        let fetchTitlesURL = try buildURL(media: media, type: type)
        
        guard let fetchTitlesURL = fetchTitlesURL else {
            throw NetworkError.urlBuildFailed
        }
        
        let (data, urlResponse) = try await URLSession.shared.data(from: fetchTitlesURL)
        
        guard let response = urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.badURLErrorResponse(underlyingError: NSError(
                domain: "DataFetcher",
                code: (urlResponse as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"]))
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        
        var titles = try decoder.decode(APIObject.self, from: data).results
        Constants.addPosterPath(to: &titles)
        
        return titles
    }
    
    private func buildURL(media: String, type: String) throws -> URL? {
        guard let baseURL = tmdbBaseURL, let apiKey = tmdbAPIKey else {
            throw NetworkError.missingConfig
        }
        
        var path: String
        
        if type == "trending" {
            path = "3/trending/\(media)/day"
        } else if type == "top_rated" {
            path = "3/\(media)/top_rated"
        } else {
            throw NetworkError.urlBuildFailed
        }
        
        guard let url = URL(string: baseURL)?
            .appending(path: path)
            .appending(queryItems: [
                URLQueryItem(name:"api_key", value: apiKey)
            ]) else {
                throw NetworkError.urlBuildFailed
            }
        
        return url
    }
        
}
