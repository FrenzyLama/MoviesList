//
//  MovieService.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 09.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import Foundation

protocol MovieService {
        func fetchMovies(from endpoint: Endpoints, completion: @escaping (Result<Wrapper, MovieAPIError>) -> ())
        func fetchMovie(id: Int, completion: @escaping (Result<Movie, MovieAPIError>) -> ())
}

enum Endpoints: String {
    var id: String { rawValue }
    
    case popular
    case nowPlaying = "now_playing"
    
    var description: String {
        switch self {
        case .popular: return "Popular"
        case .nowPlaying: return "Now Playing"
        }
    }
}

enum MovieAPIError: Error, CustomNSError {
    
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
    
    var localizedDescription: String {
        switch self {
        case .apiError: return "Failed to fetch data"
        case .invalidEndpoint: return "Invalid endpoint"
        case .invalidResponse: return "Invalid response"
        case .noData: return "No data"
        case .serializationError: return "Failed to decode data"
        }
    }
    
    var errorUserInfo: [String : Any] {
        [NSLocalizedDescriptionKey: localizedDescription]
    }
    
}
