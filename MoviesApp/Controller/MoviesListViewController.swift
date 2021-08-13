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
    
    var moviesNowPlayingDataList: MoviesData?
    var moviesUpComingDataList: MoviesData?
    var moviesSearchDataList: MoviesData?
    
    var timer = Timer()
    var counter = 0
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDelegate()
        configureDataSource()
        configureGetService()

        pageView.currentPage = 0
    }
    
    //MARK: - Configure Delegates
    func configureDelegate() {
        service.delegate = self
        sliderCollectionView.delegate = self
        upComingTableView.delegate = self
        searchMoviesBar.delegate = self
        searchBarTable.delegate = self
    }
    
    //MARK: - Configure DataSource
    func configureDataSource() {
        sliderCollectionView.dataSource = self
        upComingTableView.dataSource = self
        searchBarTable.dataSource = self
    }
    
    //MARK: - Configure GetService
    func configureGetService() {
        service.getNowPlayingMovies { nowPlayingMovies in
            self.moviesNowPlayingDataList = nowPlayingMovies
            if  nowPlayingMovies.results?.count ?? 0 > 0 {
                self.pageView.numberOfPages = nowPlayingMovies.results?.count ?? 0
                self.sliderCollectionView.reloadData()
                self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            }
        }
        service.getUpComingMovies { upComingMovies in
            self.moviesUpComingDataList = upComingMovies
            if  upComingMovies.results?.count ?? 0 > 0 {
                self.upComingTableView.reloadData()
            }
        }
    }
    
    //MARK: - Slider Change Image
    @objc func changeImage() {
        if counter < moviesNowPlayingDataList?.results?.count ?? 0 {
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

//MARK: - SegueTransfer
extension MoviesListViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVc = segue.destination as? MoviesDetailViewController
        
        if segue.identifier == Segue.searchBar {
            detailVc?.movieiD = moviesSearchDataList?.results?[index].id
        } else if segue.identifier == Segue.sliderCollection {
            detailVc?.movieiD = moviesNowPlayingDataList?.results?[index].id
        } else if segue.identifier == Segue.tableView {
            detailVc?.movieiD = moviesUpComingDataList?.results?[index].id
        }
    }
}


//MARK: - Service Delegate
extension MoviesListViewController: ServiceDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }
        
}

//MARK: - SearchBarDelegate
extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {return}
        service.getSearchMovies(searchBarText) { searchMovies in
            self.moviesSearchDataList = searchMovies
            
            if searchMovies.results?.count ?? 0 > 0 {
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        service.getSearchMovies(searchText) { searchMovies in
            self.moviesSearchDataList = searchMovies
            
            if searchMovies.results?.count ?? 0 > 0 {
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
}

//MARK: - CollectionView Delegate
extension MoviesListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: Segue.sliderCollection, sender: self)
    }
}

//MARK: - CollectionView DataSource
extension MoviesListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        moviesNowPlayingDataList?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.nowPlayinMovieCell, for: indexPath) as? NowPlayingCollectionViewCell {
            
            movieCell.configure(with: moviesNowPlayingDataList?.results?[indexPath.row].title ?? "", with: moviesNowPlayingDataList?.results?[indexPath.row].backdrop_path ?? "")
            
            cell = movieCell
        }
        
        return cell
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
            performSegue(withIdentifier: Segue.tableView, sender: self)
        } else {
            performSegue(withIdentifier: Segue.searchBar, sender: self)
        }
    }
}

//MARK: - TableViewDataSource
extension MoviesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var count = 0
        
        if upComingTableView == tableView {
            count = moviesNowPlayingDataList?.results?.count ?? 0
        } else {
            count = moviesSearchDataList?.results?.count ?? 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if upComingTableView == tableView {
            if let movieCell = upComingTableView.dequeueReusableCell(withIdentifier: Cell.upComingMovieTableViewCell, for: indexPath) as? UpComingTableViewCell {
                
                movieCell.configure(with: moviesUpComingDataList?.results?[indexPath.row].title ?? "", with: moviesUpComingDataList?.results?[indexPath.row].overview ?? "", with: moviesUpComingDataList?.results?[indexPath.row].release_date ?? "", with: moviesUpComingDataList?.results?[indexPath.row].backdrop_path ?? "")
                
                cell = movieCell
            }
        } else {
            if let movieSearchCell = searchBarTable.dequeueReusableCell(withIdentifier: Cell.searchBarMovieTableViewCell, for: indexPath) as? SearchBarTableViewCell {
                movieSearchCell.configure(with: moviesSearchDataList?.results?[indexPath.row].title ?? "")
                
                cell = movieSearchCell
            }
        }
        return cell
    }
}



