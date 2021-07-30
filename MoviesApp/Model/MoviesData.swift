//
//  MoviesData.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 28.07.2021.
//

import Foundation
struct MoviesData: Codable {
    var results: [Movies]?
}

struct Movies: Codable {
    let id: Int?
    let imdb_id: String?
    let title: String?
    let overview: String?
    let backdrop_path: String?
    let release_date: String?
    let vote_average: Double?
}

