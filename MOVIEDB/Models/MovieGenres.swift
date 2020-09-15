//
//  Genre.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 25/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation


struct MovieGenres: Codable, Hashable {

    let genres:[Genre]
    
    enum CodingKeys: String, CodingKey {
        case genres = "genres"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: MovieGenres, rhs: MovieGenres) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier = UUID()
    
}


struct Genre:Codable, Hashable{
    let id: Int?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: Genre, rhs: Genre) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier = UUID()
}
