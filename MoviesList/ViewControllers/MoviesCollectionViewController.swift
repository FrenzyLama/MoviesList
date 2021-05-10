//
//  MoviesCollectionViewController.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 09.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import UIKit



class MoviesCollectionViewController: UICollectionViewController {
    var manager = MoviesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUi), name: NSNotification.Name(rawValue: notificationKeyForUpdateMoviesList), object: nil)
        fetchMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            let movieVC = segue.destination as! MovieDetailsViewController
            let cell = sender as! MovieCell
            movieVC.image = cell.posterImage.image
            movieVC.titleText = cell.titleText.text
            movieVC.yearText = cell.releaseYear
            movieVC.idMovie = cell.id
        }
    }
    
    func fetchMovies() {
        manager.loadMovies(with: .popular)
    }
    
    @objc func updateUi() {
        collectionView.reloadData()
    }
    
    func handleError(apiError: MovieAPIError) {
        let alertController =
            UIAlertController(title: "Error",
                              message: apiError.localizedDescription,
                              preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
}

// MARK: - UICollectionViewDelegate/DataSource

extension MoviesCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(manager.movies.count)
        return manager.movies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.prepare(movie: manager.movies[indexPath.row])
        return cell
    }
}



