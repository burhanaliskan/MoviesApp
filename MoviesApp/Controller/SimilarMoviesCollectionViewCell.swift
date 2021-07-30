//
//  SimilarMoviesCollectionViewCell.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 30.07.2021.
//

import UIKit

class SimilarMoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviesImageView: UIImageView!
    @IBOutlet weak var moviesTitleLabel: UILabel!
    
    //MARK: - Configure Cell
    func configure(with movieTitle: String, with imageLink: String) {
        moviesTitleLabel.text = movieTitle
        
        Helper.setImage(with: Api.imdbImageLink + imageLink, with: moviesImageView, with: 5)
    }
}
