//
//  NowPlayingItem.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 09/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit
import JGProgressHUD

class NowPlayingItem: UICollectionViewCell {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel! 
    let spinner = JGProgressHUD(style: .dark)
    
    static let identifier = "nowplayingitem"
    
    static func nib() -> UINib?{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    
    func parseData(movie: MovieResult){
        imageFetcher(path: movie.movieImage)
        self.movieTitle.text = movie.movieTitle
    }
    
    
    private func imageFetcher(path:String?){
        guard let path = path else { return }
        self.movieImage.loadImageFromUrl(path: path)
        spinner.dismiss()
        self.movieImage.contentMode = .scaleToFill
    }
    
    
}
