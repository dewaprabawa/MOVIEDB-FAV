//
//  Delegates.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 25/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

protocol MovieListDelegate {

    func seeAllMovies(type: MovieType)
    
    func movieDetail(item: MovieResult)
}


protocol DetailMovieDelegate {
    func movieDetail(_ data:MovieResult)
}
