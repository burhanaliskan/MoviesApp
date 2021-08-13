//
//  Service.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 28.07.2021.
//

import Foundation
import Alamofire

protocol ServiceDelegate {
    func didFailWithError(error: Error)
}

class Service {
    
    fileprivate var baseUrl = Api.baseUrl
    
    var delegate: ServiceDelegate?
    
    //MARK: - GetNowPlaying Movies
    func getNowPlayingMovies(completion: @escaping(MoviesData) -> Void) {
        let url = baseUrl + "/movie/now_playing?api_key=" + Api.apiKey
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            
            guard let moviesNowPlaying = self.parseJsonCollection(data) else {return}
            completion(moviesNowPlaying)
        }
    }
    
    //MARK: - GetUpComing Movies
    func getUpComingMovies(completion: @escaping(MoviesData) -> Void) {
        let url = baseUrl + "/movie/upcoming?api_key=" + Api.apiKey
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            
            guard let moviesUpComing = self.parseJsonCollection(data) else {return}
            completion(moviesUpComing)
        }
    }
    
    
    //MARK: - getSearchMovies
    func getSearchMovies(_ query: String, completion: @escaping(MoviesData) -> Void) {
        
        if query.count >= 2 || query.isEmpty {
            let url = baseUrl + "/search/movie?query=\(query)&api_key=" + Api.apiKey
            AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
                (responseData) in
                guard let data = responseData.data else {return}
                
                guard let moviesSearch = self.parseJsonCollection(data) else {return}
                completion(moviesSearch)
            }
        }
    }
    
    //MARK: - getMovieDeteail
    func getMovieDetail(_ movieId: Int, completion: @escaping(Movies) -> Void) {
        let url = baseUrl + "/movie/" + String(movieId)  + "?api_key=" + Api.apiKey
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            
            guard let moviesDetail = self.parseJsonDetail(data) else {return}
            completion(moviesDetail)
        }
    }
    
    //MARK: - getSmilarMovies
    func getSmilarMovies(_ movieId: Int, completion: @escaping(MoviesData) -> Void) {
        let url = baseUrl + "/movie/" + String(movieId)  + "/similar?api_key=" + Api.apiKey
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil).response {
            (responseData) in
            guard let data = responseData.data else {return}
            
            guard let moviesSmilar = self.parseJsonCollection(data) else {return}
            completion(moviesSmilar)
        }
    }
    
    //MARK: - ParseJsonCollection
    func parseJsonCollection(_ moviesData: Data) -> MoviesData? {
        let decoder = JSONDecoder()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Date.dateFormatterGet
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Date.dateFormatterPrint
        
        do {
            let decodeData = try decoder.decode(MoviesData.self, from: moviesData)
            

            return decodeData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARK: - ParseJsonDetail
    func parseJsonDetail(_ moviesData: Data) -> Movies? {
        let decoder = JSONDecoder()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Date.dateFormatterGet
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Date.dateFormatterPrint
        
        do {
            let decodeData = try decoder.decode(Movies.self, from: moviesData)

            return decodeData
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}




