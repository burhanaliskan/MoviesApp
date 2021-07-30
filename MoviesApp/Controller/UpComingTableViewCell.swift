//
//  UpComingTableViewCell.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 29.07.2021.
//

import UIKit

class UpComingTableViewCell: UITableViewCell {

    @IBOutlet weak var upComingImageView: UIImageView!
    @IBOutlet weak var upComingMovieTitleLabel: UILabel!
    @IBOutlet weak var upComingOverviewLabel: UILabel!
    @IBOutlet weak var upComingDateLabel: UILabel!
    
    //MARK: - Configure Cell
    func configure(with movieTitle: String, with movieDescription: String, with movieReleaseDate: String, with movieImageLink: String) {
        upComingMovieTitleLabel.text = movieTitle
        upComingOverviewLabel.text = movieDescription
        upComingDateLabel.text = movieReleaseDate
        
        Helper.setImage(with: Api.imdbImageLink + movieImageLink, with: upComingImageView, with: 5)
    }
}
