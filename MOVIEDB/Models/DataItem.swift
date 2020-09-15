//
//  DataItem.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 06/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import Foundation


struct DataItem {
    let nowPlaying:MovieResult
    let topRated:MovieResult
    let popularMovie:MovieResult
    let genre:Genre
}


struct Section<T: Hashable, U: Hashable>: Hashable {
    let headerItem: T
    let sectionItems: U
}

struct DataSource<T: Hashable> {
    let sections: [T]
}


class NowPlayingSection:SectionAdaptable, Hashable {
    
    var items: [MovieResult]?
    
    var sectionTitle = "Now Playing"
    
    init(items:[MovieResult]) {
        self.items = items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: NowPlayingSection, rhs: NowPlayingSection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier = UUID()
}

class TopRatedSection:SectionAdaptable, Hashable {
    
    var items: [MovieResult]?
    
    var sectionTitle = "Top Rated"
    
    init(items:[MovieResult]) {
        self.items = items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: TopRatedSection, rhs: TopRatedSection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier = UUID()
}


class PopularMovieSection:SectionAdaptable, Hashable {
    
    var items: [MovieResult]?
    
    var sectionTitle = "Popular Movie"
    
    init(items:[MovieResult]) {
        self.items = items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: PopularMovieSection, rhs: PopularMovieSection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier = UUID()
}



class GenreListSection:SectionAdaptable, Hashable {
    
    var items: [Genre]?
    
    var sectionTitle = "Genre List"
    
    init(items:[Genre]) {
        self.items = items
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: GenreListSection, rhs: GenreListSection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    private var identifier = UUID()
}



