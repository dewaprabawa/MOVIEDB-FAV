//
//  MovieListCell.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 25/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

class MovieListCell: UITableViewCell {

    static var identifier = "MovieListCell"
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var cellContainer: UIView!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    
    
    func parseData(movie: MovieResult?){
        guard let movie = movie else {
            return
        }
        self.rate.text = "\(movie.movieVoteAverage!)"
        self.title.text = movie.movieTitle
        self.releaseDate.text = movie.movieReleaseData
        self.imageFetcher(path: movie.movieImage)
        self.cellContainer.dropCornerAndShadow()
    }

    private func imageFetcher(path:String?){
        guard let path = path else {
            return
        }
        self.movieImage.loadImageFromUrl(path: path)
        self.movieImage.applyshadowWithCorner(containerView: imageContainer, cornerRadious: 10)
    }
}
