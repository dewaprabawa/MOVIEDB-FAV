//
//  Movie.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 09/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation

struct Movie: Codable, Hashable {
    let page: Int?
    let total_pages: Int?
    let results: [MovieResult]
    
     func hash(into hasher: inout Hasher) {
       hasher.combine(identifier)
     }

     static func == (lhs: Movie, rhs: Movie) -> Bool {
       return lhs.identifier == rhs.identifier
     }

     private let identifier = UUID()
}


struct MovieResult: Codable, Hashable {
    let movieTitle:String?
    let movieId:Int?
    let movieReleaseData:String?
    let movieImage:String?
    let movieImageBackDrop: String?
    let moviePopularity: Double?
    let movieVoteAverage: Double?
    let Genres:[Int?]
    
    
    enum CodingKeys: String, CodingKey {
        case movieTitle = "title"
        case movieId = "id"
        case movieReleaseData = "release_date"
        case movieImage = "poster_path"
        case movieImageBackDrop = "backdrop_path"
        case moviePopularity = "popularity"
        case movieVoteAverage = "vote_average"
        case Genres = "genre_ids"
    }
    
}
