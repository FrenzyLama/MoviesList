//
//  MoviesCollectionViewController.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 09.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import UIKit

let notifikationKeyForUpdateUi = "UpdateUi"

class MoviesCollectionViewController: UICollectionViewController {
    
    //MARK: - FlowLayoutProperties
    let itemsPerRow: CGFloat = 2
    let sectionInserts = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    
    var manager = MoviesManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUi), name: NSNotification.Name(rawValue: notifikationKeyForUpdateUi), object: nil)
        fetchMovies()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetails" {
            let movieVC = segue.destination as! MovieDetailsViewController
            let cell = sender as! MovieCell
            movieVC.image = cell.posterImage.image
            movieVC.titleText = cell.titleText.text
            movieVC.yearText = cell.releaseYear
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
        print("title \(manager.movies[indexPath.row].title)")
        cell.prepare(movie: manager.movies[indexPath.row])
        return cell
    }
}

//// MARK: - UICollectionViewDelegateFlowLayout
//extension MoviesCollectionViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
//        let availableWidth = collectionView.frame.width - paddingWidth
//        let widthPerItem = availableWidth / itemsPerRow
//        let heightPerItem = availableWidth 
//        return CGSize(width: widthPerItem, height: heightPerItem)
//    }
//    
////      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
////        return CGSize(width: itemSize, height: itemSize)
////      }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return sectionInserts
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInserts.left
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return sectionInserts.left
//    }
//}
//
////extension MoviesCollectionViewController: MoviesLayoutDelegate {
////  func collectionView(
////    _ collectionView: UICollectionView,
////    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
////            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
////    let image = cell.posterImage.image
////    return image?.size.height ?? 150
////  }
////}


