//
//  UpComingTableViewCell.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 29.07.2021.
//

import UIKit
import Kingfisher

class UpComingTableViewCell: UITableViewCell {

    @IBOutlet weak var upComingImageView: UIImageView!
    @IBOutlet weak var upComingMovieTitleLabel: UILabel!
    @IBOutlet weak var upComingOverviewLabel: UILabel!
    @IBOutlet weak var upComingDateLabel: UILabel!
    
    
    func configure(with movieTitle: String, with movieDescription: String, with movieReleaseDate: String, with movieImageLink: String) {
        upComingMovieTitleLabel.text = movieTitle
        upComingOverviewLabel.text = movieDescription
        upComingDateLabel.text = movieReleaseDate
        
        let url = URL(string: Api.imdbImageLink + movieImageLink)
        let processor = DownsamplingImageProcessor(size: upComingImageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 5)
        upComingImageView.kf.indicatorType = .activity
        upComingImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    @IBAction func detailMovieButtonPressed(_ sender: UIButton) {
    }
}
