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
    
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImage: UIImageView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        posterImage.image = image
        titleLabel.text = titleText
        releaseYearLabel.text = yearText
    }
}
