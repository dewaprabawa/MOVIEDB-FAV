//
//  GenreCell.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 06/09/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

class GenreCell: UICollectionViewCell {
    static var identifier = "GenreCell"
    static func nib() -> UINib?{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genreViewContainer: UIView!
    
    func parseData(genre: Genre){
        self.genreLabel.text = genre.name
        self.genreViewContainer.layer.cornerRadius = 10
        self.genreViewContainer.layer.masksToBounds = true
    }
}
