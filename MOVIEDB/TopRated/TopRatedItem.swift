//
//  TopRatedItem.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 19/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

class TopRatedItem: UICollectionViewCell {

    static var identifier = "TopRatedItem"
     
     static func nib() -> UINib {
         return UINib(nibName: String(describing: self), bundle: nil)
     }
    
    @IBOutlet weak var movieImage:UIImageView!
    @IBOutlet weak var movieTile:UILabel!
 

    func parseData(movie:MovieResult){
        self.movieTile.text = movie.movieTitle
        imageFetcher(path: movie.movieImage)
    }
    
    private func imageFetcher(path:String?){
        guard let path = path else { return }
   
        self.movieImage.loadImageFromUrl(path: path)
        self.movieImage.contentMode = .scaleToFill
 
    }

}
