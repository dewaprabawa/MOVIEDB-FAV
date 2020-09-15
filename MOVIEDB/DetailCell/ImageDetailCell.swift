//
//  ImageDetailCell.swift
//  MOVIEDB
//
//  Created by Dewa Prabawa on 27/08/20.
//  Copyright © 2020 Dewa Prabawa. All rights reserved.
//

import UIKit

class ImageDetailCell: UICollectionViewCell {

    static var identifier = "ImageDetailCell"
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var nameDetailLabel: UILabel!

}
