//
//  NowPlayingCollectionViewCell.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 29.07.2021.
//

import UIKit

class NowPlayingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nowPlayingImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    //MARK: - Configure Cell
    func configure(with movieTitle: String, with imageLink: String) {
        movieTitleLabel.text = movieTitle
                
        Helper.setImage(with: Api.imdbImageLink + imageLink, with: nowPlayingImageView)
    }
}
