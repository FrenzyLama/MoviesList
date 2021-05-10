//
//  CastMovieCell.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 10.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import UIKit

class CastMovieCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var actorNameLabel: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }
     
     var imageURL: URL? {
         didSet {
             profileImageView?.image = nil
             updateUI()
         }
     }
     
     private func updateUI() {
         if let url = imageURL {
//             activityIndicator?.startAnimating()
             DispatchQueue.global(qos: .userInitiated).async {
                 let contentsOfURL = try? Data(contentsOf: url)
                 DispatchQueue.main.async {
                     if url == self.imageURL {
                         if let imageData = contentsOfURL {
                             self.profileImageView?.image = UIImage(data: imageData)
                         }
//                         self.activityIndicator?.stopAnimating()
//                         self.activityIndicator?.hidesWhenStopped = true
                     }
                 }
             }
         }
     }
     
     func prepare(actor: Actor) {
         print(actor)
        characterLabel.text = actor.character
        actorNameLabel.text = actor.name
        if let profileImage = actor.profilePath {
        imageURL = URL(string: NetworkOperations.shared.posterBaseUrl + profileImage )
        } else {
            profileImageView.image = UIImage(named: "Portrait_Placeholder")
        }
     }
}

