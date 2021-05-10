//
//  MovieCell.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 09.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell, SelfIdentifing {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleText: UILabel!
    var releaseYear: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var imageURL: URL? {
        didSet {
            posterImage?.image = nil
            updateUI()
        }
    }
    
    private func updateUI() {
        if let url = imageURL {
            activityIndicator?.startAnimating()
            DispatchQueue.global(qos: .userInitiated).async {
                let contentsOfURL = try? Data(contentsOf: url)
                DispatchQueue.main.async {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.posterImage?.image = UIImage(data: imageData)
                        }
                        self.activityIndicator?.stopAnimating()
                        self.activityIndicator?.hidesWhenStopped = true
                    }
                }
            }
        }
    }
    
    func prepare(movie: Movie) {
        print(movie)
        titleText.text = movie.title
        imageURL = URL(string: NetworkLayer.shared.posterBaseUrl + movie.poster)
        releaseYear = movie.yearText
    }
}

protocol SelfIdentifing {
    static var reuseIdentifier: String { get }
}

extension SelfIdentifing {
    static var reuseIdentifier: String {
        return "\(self)"
    }
}

