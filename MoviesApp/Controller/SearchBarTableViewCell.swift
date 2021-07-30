//
//  SearchBarTableViewCell.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 29.07.2021.
//

import UIKit

class SearchBarTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitleLabel: UILabel!
    

    func configure(with movieTitle: String) {
        movieTitleLabel.text = movieTitle
    }
    
}
