//
//  NowPlayingCollectionViewCell.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 29.07.2021.
//

import UIKit
import Kingfisher

class NowPlayingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nowPlayingImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    
    
    func configure(with movieTitle: String, with imageLink: String) {
        movieTitleLabel.text = movieTitle
        
        let url = URL(string: Api.imdbImageLink + imageLink)
        let processor = DownsamplingImageProcessor(size: nowPlayingImageView.bounds.size)
                     
        nowPlayingImageView.kf.indicatorType = .activity
        nowPlayingImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
