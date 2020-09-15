//
//  latestPlayingItem.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 18/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

class LatestPlayingItem: UICollectionViewCell {

    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    
    static let identifier = "LatestPlayingItem"
      
    static func nib() -> UINib?{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    func parseData(movie:MovieResult){
        self.movieTitle.text = movie.movieTitle
        let path = movie.movieImage
        imageFetcher(path: path)
    }
    
    private func imageFetcher(path:String?){
        
        guard let path = path else { return }        
        self.movieImage.loadImageFromUrl(path: path)
        self.movieImage.contentMode = .scaleToFill
            
    }
    


}
