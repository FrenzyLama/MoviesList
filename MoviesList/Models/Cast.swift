//
//  Cast.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 10.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import Foundation

struct Credits: Codable, Hashable {
    let cast : [Actor]
}

struct Actor: Codable, Hashable {
    let name : String?
    let profilePath: String?
    let character: String?
    
    enum CodingKeys: String, CodingKey{
        case name
        case profilePath = "profile_path"
        case character
    }
}
