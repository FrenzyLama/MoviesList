//
//  NetworkOperations.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 09.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import Foundation

class NetworkOperations: MovieService {
    static let shared = NetworkOperations()
    private init() {}
    
    private var baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "b72d267f9069ec99399388918e2c927e"
    private let urlSession = URLSession.shared
    private let jsonDecoder = DecodeConfiguration.decoder
    let posterBaseUrl: String = "https://image.tmdb.org/t/p/w185"
    
    func fetchMovies(from endpoint: Endpoints, completion: @escaping (Result<Wrapper, MovieAPIError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    func fetchMovieDetails(id: Int, completion: @escaping (Result<Credits, MovieAPIError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(String(id))/credits") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        self.loadURLAndDecode(url: url, completion: completion)
    }
    
    private func loadURLAndDecode<D: Codable>(url: URL, params: [String: String]? = nil, completion: @escaping (Result<D, MovieAPIError>) -> ()) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        if let params = params {
            queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        }
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlSession.dataTask(with: finalURL) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if error != nil {
                self.executeCompletionHandlerInMainThread(with: .failure(.apiError), completion: completion)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                self.executeCompletionHandlerInMainThread(with: .failure(.invalidResponse), completion: completion)
                return
            }
            guard let data = data else {
                self.executeCompletionHandlerInMainThread(with: .failure(.noData), completion: completion)
                return
            }
            
            do {
                let decodedResponse = try self.jsonDecoder.decode(D.self, from: data)
                self.executeCompletionHandlerInMainThread(with: .success(decodedResponse), completion: completion)
            } catch {
                self.executeCompletionHandlerInMainThread(with: .failure(.serializationError), completion: completion)
            }
        }.resume()
    }
    
    private func executeCompletionHandlerInMainThread<D: Codable>(with result: Result<D, MovieAPIError>, completion: @escaping (Result<D, MovieAPIError>) -> ()) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    private func generateURL(with endpoint: Endpoints) -> URL? {
        guard var urlComponents = URLComponents(string: "\(baseURL)/movie/\(endpoint.rawValue)") else {
            return nil
        }
        
        let queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
