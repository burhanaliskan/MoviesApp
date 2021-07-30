//
//  SimilarMoviesCollectionViewCell.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 30.07.2021.
//

import UIKit
import Kingfisher

class SimilarMoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviesImageView: UIImageView!
    @IBOutlet weak var moviesTitleLabel: UILabel!
    
    
    func configure(with movieTitle: String, with imageLink: String) {
        moviesTitleLabel.text = movieTitle
        
        let url = URL(string: Api.imdbImageLink + imageLink)
        let processor = DownsamplingImageProcessor(size: moviesImageView.bounds.size)
                     
        moviesImageView.kf.indicatorType = .activity
        moviesImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
}
