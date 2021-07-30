//
//  Service.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 28.07.2021.
//

import Foundation
import Alamofire

protocol ServiceDelegate {
    func didUpdateMoviesNowPlaying(_ service: Service, movieModel: [MoviesModel])
    func didUpdateMoviesUpComing(_ service: Service, movieModel: [MoviesModel])
    func didUpdateMoviesSearch(_ service: Service, movieModel: [MoviesModel])
    func didUpdateMoviesDetail(_ service: Service, movieModel: MoviesModel)
    func didUpdateMoviesSimilar(_ service: Service, movieModel: [MoviesModel])
    func didFailWithError(error: Error)
}

class Service {
    
    fileprivate var baseUrl = Api.baseUrl
    
    var delegate: ServiceDelegate?
    
    //MARK: - GetNowPlaying Movies
    func getNowPlayingMovies() {
        let url = baseUrl + "/movie/now_playing?api_key=" + Api.apiKey
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            
            guard let moviesNowPlaying = self.parseJsonCollection(data) else {return}
            self.delegate?.didUpdateMoviesNowPlaying(self, movieModel: moviesNowPlaying)
        }
    }
    
    //MARK: - GetUpComing Movies
    func getUpComingMovies() {
        let url = baseUrl + "/movie/upcoming?api_key=" + Api.apiKey
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            
            guard let moviesUpComing = self.parseJsonCollection(data) else {return}
            self.delegate?.didUpdateMoviesUpComing(self, movieModel: moviesUpComing)
        }
        
    }
    
    
    //MARK: - getSearchMovies
    func getSearchMovies(_ query: String) {
        
        if query.count >= 2 || query.isEmpty {
            let url = baseUrl + "/search/movie?query=\(query)&api_key=" + Api.apiKey
            AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
                (responseData) in
                guard let data = responseData.data else {return}
                
                guard let moviesSearch = self.parseJsonCollection(data) else {return}
                self.delegate?.didUpdateMoviesSearch(self, movieModel: moviesSearch)
            }
        }
    }
    
    //MARK: - getMovieDeteail
    func getMovieDetail(_ movieId: Int) {
        let url = baseUrl + "/movie/" + String(movieId)  + "?api_key=" + Api.apiKey
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            
            guard let moviesDetail = self.parseJsonDetail(data) else {return}
            self.delegate?.didUpdateMoviesDetail(self, movieModel: moviesDetail)
        }
    }
    
    //MARK: - getSmilarMovies
    func getSmilarMovies(_ movieId: Int) {
        let url = baseUrl + "/movie/" + String(movieId)  + "/similar?api_key=" + Api.apiKey
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            
            guard let moviesSmilar = self.parseJsonCollection(data) else {return}
            self.delegate?.didUpdateMoviesSimilar(self, movieModel: moviesSmilar)
        }
    }
    
    //MARK: - ParseJsonCollection
    func parseJsonCollection(_ moviesData: Data) -> [MoviesModel]? {
        let decoder = JSONDecoder()
        var movieDataList: [MoviesModel] = []
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Date.dateFormatterGet
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Date.dateFormatterPrint
        
        do {
            let decodeData = try decoder.decode(MoviesData.self, from: moviesData)
            
            if let data = decodeData.results {
                if decodeData.results!.count > 0 {
                    for index in 0 ... data.count - 1 {
                        
                        let id = data[index].id
                        let imdbId = data[index].imdb_id
                        let movieTitle = data[index].title
                        let description = data[index].overview
                        let image = data[index].backdrop_path
                        var releaseDate = ""
                        if let date = dateFormatterGet.date(from: (data[index].release_date ?? "")) {
                            releaseDate = dateFormatterPrint.string(from: date)
                        }
                        let voteAverage = String(format: "%.1f", data[index].vote_average ?? "")
                        
                        let movies = MoviesModel(id: id, imdbId: imdbId, movieTitle: movieTitle, description: description, image: image, releaseDate: releaseDate, voteAverage: voteAverage)
                        
                        movieDataList.append(movies)
                    }
                }
            }
            return movieDataList
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARK: - ParseJsonDetail
    func parseJsonDetail(_ moviesData: Data) -> MoviesModel? {
        let decoder = JSONDecoder()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Date.dateFormatterGet
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Date.dateFormatterPrint
        
        do {
            let decodeData = try decoder.decode(MovieDetailData.self, from: moviesData)

            let id = decodeData.id
            let imdbId = decodeData.imdb_id
            let movieTitle = decodeData.title
            let description = decodeData.overview
            let image = decodeData.backdrop_path
            var releaseDate = ""
            if let date = dateFormatterGet.date(from: (decodeData.release_date ?? "")) {
                releaseDate = dateFormatterPrint.string(from: date)
            }
            let voteAverage = String(format: "%.1f", decodeData.vote_average ?? "")
            
            let movies = MoviesModel(id: id, imdbId: imdbId, movieTitle: movieTitle, description: description, image: image, releaseDate: releaseDate, voteAverage: voteAverage)
            
            return movies
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}




