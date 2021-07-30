//
//  Constants.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 28.07.2021.
//

import Foundation

enum Api {
    static let baseUrl = "https://api.themoviedb.org/3"
    static let apiKey = "3208635d1cc03aa03f6777238ebb58cf"
    static let imdbImageLink = "https://image.tmdb.org/t/p/w500"
    static let imdbLink = "https://www.imdb.com/title/"
}

enum Segue {
    static let searchBar = "searchBarSegue"
    static let sliderCollection = "sliderCollectionSegue"
    static let tableView = "tableViewSegue"
    static let goToMovieList = "goToMoviesList"
    static let similarMovieDetailSegue = "similarMovieDetailSegue"
}

enum  Cell {
    static let nowPlayinMovieCell = "NowPlayingMovieCell"
    static let upComingMovieTableViewCell = "UpComingTableViewCell"
    static let searchBarMovieTableViewCell = "SearchBarTableViewCell"
    static let similarMoviesCell = "SimilarMoviesCell"
}

enum Keywords {
    static let home = "Home"
}

enum Date {
    static let dateFormatterGet = "yyyy-MM-dd"
    static let dateFormatterPrint = "dd.MM.yyyy"
}

