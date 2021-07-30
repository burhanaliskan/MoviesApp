//
//  ViewController.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 28.07.2021.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var searchMoviesBar: UISearchBar!
    
    @IBOutlet weak var searchBarTableView: UIView!
    @IBOutlet weak var searchBarTable: UITableView!

    @IBOutlet weak var viewSliderCollection: UIView!
    @IBOutlet weak var sliderCollectionView: UICollectionView!
    @IBOutlet weak var pageView: UIPageControl!
    
    @IBOutlet weak var viewTable: UIView!
    @IBOutlet weak var upComingTableView: UITableView!
    
    
    let service = Service()
    
    var moviesNowPlayingDataList: [MoviesModel] = []
    var moviesUpComingDataList: [MoviesModel] = []
    var moviesSearchDataList: [MoviesModel] = []

    var timer = Timer()
    var counter = 0
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.delegate = self
        sliderCollectionView.delegate = self
        sliderCollectionView.dataSource = self
        
        upComingTableView.delegate = self
        upComingTableView.dataSource = self
        
        searchMoviesBar.delegate = self
        
        searchBarTable.delegate = self
        searchBarTable.dataSource = self
                
        service.getNowPlayingMovies()
        service.getUpComingMovies()
        pageView.currentPage = 0
        
    }
    
    
    @objc func changeImage() {
        if counter < moviesNowPlayingDataList.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter = 1
        }
    }
    
}

//MARK: - Service Delegate
extension MoviesListViewController: ServiceDelegate {
   
    func didUpdateMoviesUpComing(_ service: Service, movieModel: [MoviesModel]) {
        DispatchQueue.main.async {
            self.moviesUpComingDataList = movieModel
            self.upComingTableView.reloadData()
        }
    }
    
    func didUpdateMoviesNowPlaying(_ service: Service, movieModel: [MoviesModel]) {
        DispatchQueue.main.async {
            self.moviesNowPlayingDataList = movieModel
            self.pageView.numberOfPages = movieModel.count
            self.sliderCollectionView.reloadData()
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
    }
    
    func didUpdateMoviesSearch(_ service: Service, movieModel: [MoviesModel]) {
        DispatchQueue.main.async {
            self.moviesSearchDataList = movieModel
            
            if movieModel.count > 0 {
                self.searchBarTable.reloadData()
                self.searchBarTableView.isHidden = false
                self.viewSliderCollection.isHidden = true
                self.viewTable.alpha = 0.5
            } else {
                self.searchBarTableView.isHidden = true
                self.viewSliderCollection.isHidden = false
                self.viewTable.alpha = 1.0
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateMoviesDetail(_ service: Service, movieModel: MoviesModel) {}
    
    func didUpdateMoviesSimilar(_ service: Service, movieModel: [MoviesModel]) {}
}


//MARK: - CollectionView DataSource
extension MoviesListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesNowPlayingDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NowPlayingMovieCell", for: indexPath) as? NowPlayingCollectionViewCell {
            
            movieCell.configure(with: moviesNowPlayingDataList[indexPath.row].movieTitle!, with: moviesNowPlayingDataList[indexPath.row].image!)

            cell = movieCell
        }
        
        return cell
    }
}

//MARK: - CollectionView Delegate
extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "sliderCollectionSegue", sender: self)
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension MoviesListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = sliderCollectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

//MARK: - TableViewDelegate {
extension MoviesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        if upComingTableView == tableView {
            performSegue(withIdentifier: "tableViewSegue", sender: self)
        } else {
            performSegue(withIdentifier: "searchBarSegue", sender: self)
        }
    }
}

//MARK: - TableViewDataSource
extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if upComingTableView == tableView {
           count = moviesNowPlayingDataList.count
        } else {
           count = moviesSearchDataList.count
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if upComingTableView == tableView {
            if let movieCell = upComingTableView.dequeueReusableCell(withIdentifier: "UpComingTableViewCell", for: indexPath) as? UpComingTableViewCell {
                
                movieCell.configure(with: moviesUpComingDataList[indexPath.row].movieTitle!, with: moviesUpComingDataList[indexPath.row].description!, with: moviesUpComingDataList[indexPath.row].releaseDate!, with: moviesUpComingDataList[indexPath.row].image!)
                
                cell = movieCell
            }
        } else {
            if let movieSearchCell = searchBarTable.dequeueReusableCell(withIdentifier: "SearchBarTableViewCell", for: indexPath) as? SearchBarTableViewCell {
                movieSearchCell.configure(with: moviesSearchDataList[indexPath.row].movieTitle!)
                
                cell = movieSearchCell
            }
        }
        return cell
    }
}

//MARK: - SearchBarDelegate
extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        service.getSearchMovies(searchBarText)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        service.getSearchMovies(searchText)
    }
}

//MARK: - SegueTransfer
extension MoviesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVc = segue.destination as? MoviesDetailViewController

        if segue.identifier == "searchBarSegue" {
            detailVc?.movieiD = moviesSearchDataList[index].id
        } else if segue.identifier == "sliderCollectionSegue" {
            detailVc?.movieiD = moviesNowPlayingDataList[index].id
        } else if segue.identifier == "tableViewSegue" {
            detailVc?.movieiD = moviesUpComingDataList[index].id
        }
    }
}
