//
//  MoviesManager.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 09.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import Foundation

class MoviesManager {
    
    var movies = [Movie]()
    var isLoading: Bool = false
    var error: NSError?
    
    private let movieService: MovieService
    
    init(movieService: MovieService = NetworkLayer.shared) {
        self.movieService = movieService
    }
    
    func loadMovies(with endpoint: Endpoints) {
        self.isLoading = true
        self.movieService.fetchMovies(from: endpoint) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                print(response)
                self.movies = response.results
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifikationKeyForUpdateUi), object: nil)
                
            case .failure(let error):
                print(error)
                self.error = error as NSError
            }
        }
    }
}
