//
//  Errors.swift
//  BlossomMovie
//
//  Created by Ankit Ammanagi on 13/06/26.
//

import Foundation

enum APIConfigError: Error, LocalizedError {
    case fileNotFound
    case decodingFailed(underlyingError: Error)
    case failedToLoadData(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return "APIConfig.json file not found in the bundle."
        case .decodingFailed(let underlyingError):
            return "Failed to decode APIConfig.json: \(underlyingError.localizedDescription)"
        case .failedToLoadData(let underlyingError):
            return "Failed to load data from APIConfig.json: \(underlyingError.localizedDescription)"
        }
    }
}

enum NetworkError: Error, LocalizedError {
    case urlBuildFailed
    case missingConfig
    case badURLErrorResponse(underlyingError: Error)
    
    var errorDescription: String? {
        switch self {
        case .missingConfig:
            return "APIConfig is missing. Please ensure that APIConfig.json is present in the bundle."
            
        case .badURLErrorResponse(let underlyingError):
            return "Failed to get a valid response from the base URL: \(underlyingError.localizedDescription)"
        case .urlBuildFailed:
            return "Failed to construct the URL for the API request. Please check the base URL and query parameters."
        }
    }
}
