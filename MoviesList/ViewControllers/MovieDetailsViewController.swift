//
//  MovieDetailsViewController.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 10.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import UIKit


class MovieDetailsViewController: UIViewController {
    var image: UIImage?
    var titleText: String?
    var yearText: String?
    var idMovie: Int?
    
    var manager = MoviesManager()
    
    @IBOutlet weak var castMovieCollectionView: UICollectionView!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.castMovieCollectionView.dataSource = self
        self.castMovieCollectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUi), name: NSNotification.Name(rawValue: notificationKeyForUpdateMovieDetailsUi), object: nil)
        fetchCastDetails()
        posterImage.image = image
        titleLabel.text = titleText
        releaseYearLabel.text = yearText
    }
    
    func fetchCastDetails() {
        if let id = idMovie {
            manager.loadMovieDetails(id: id)
        }
    }
    
    @objc func updateUi() {
        castMovieCollectionView.reloadData()
    }
}

extension MovieDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  manager.movieCast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastMovieCell", for: indexPath) as! CastMovieCell
        cell.prepare(actor: manager.movieCast[indexPath.row])
        print("!!!!!!")
        return cell
    }
}
