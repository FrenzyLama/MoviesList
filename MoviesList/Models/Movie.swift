//
//  Movie.swift
//  MoviesList
//
//  Created by Gleb Ilchyshyn on 09.05.2021.
//  Copyright © 2021 Gleb Ilchyshyn. All rights reserved.
//

import Foundation

struct Wrapper: Codable, Hashable {
    let results: [Movie]
}

struct Movie: Codable, Hashable {
    let title: String
    let poster: String
    let backdropPath: String
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey{
        case title
        case poster = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Movie.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Movie.yearFormatter.string(from: date)
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        return dateFormatter
    }()
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
}


