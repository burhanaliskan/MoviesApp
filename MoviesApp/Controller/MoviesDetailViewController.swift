//
//  MoviesDetailViewController.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 30.07.2021.
//

import UIKit
import Kingfisher

class MoviesDetailViewController: UIViewController {
    
    @IBOutlet weak var moviesDetailImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UILabel!
    @IBOutlet weak var movieAverageLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var imdbButton: UIButton!
    @IBOutlet weak var similarMoviesCollectionView: UICollectionView!
    
    
    var movieiD: Int?
    var service = Service()
    var moviesDetail: MoviesModel?
    var similarMoviesData: [MoviesModel] = []
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        service.delegate = self
        service.getMovieDetail(movieiD ?? 0)
        service.getSmilarMovies(movieiD ?? 0)
        navigationConfigure()
        
        similarMoviesCollectionView.dataSource = self
        similarMoviesCollectionView.delegate = self
        
        let image = #imageLiteral(resourceName: "ImdbLogo")
        imdbButton.setBackgroundImage(image, for: .normal)
        
        imdbButton.addTarget(self, action: "imdbButtonPressed:", for: .touchUpInside)
    }
    
    @IBAction func imdbButtonPressed(_ sender: UIButton) {
        guard var imdb = moviesDetail?.imdbId else { return }
        UIApplication.shared.openURL(URL(string: "https://www.imdb.com/title/" + imdb)!)
    }
    
    @objc func goHomePage() {
        performSegue(withIdentifier: "goToMoviesList", sender: self)
    }
    
    func navigationConfigure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Home", style: .done, target: self, action: #selector(goHomePage) )
    }
}


//MARK: - ServiceDelegate
extension MoviesDetailViewController: ServiceDelegate {
    func didUpdateMoviesSimilar(_ service: Service, movieModel: [MoviesModel]) {
        DispatchQueue.main.async {
            self.similarMoviesData = movieModel
            self.similarMoviesCollectionView.reloadData()
        }
    }
    
    
    func didUpdateMoviesDetail(_ service: Service, movieModel: MoviesModel) {
        DispatchQueue.main.async {
            self.moviesDetail = movieModel
            self.configure()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didUpdateMoviesNowPlaying(_ service: Service, movieModel: [MoviesModel]) {}
    
    func didUpdateMoviesUpComing(_ service: Service, movieModel: [MoviesModel]) {}
    
    func didUpdateMoviesSearch(_ service: Service, movieModel: [MoviesModel]) {}
}

//MARK: - ConfigureObjects
extension MoviesDetailViewController {
    
    func configure() {
        movieTitleLabel.text = moviesDetail?.movieTitle
        movieDescriptionLabel.text = moviesDetail?.description
        movieAverageLabel.text = moviesDetail?.voteAverage
        movieReleaseDateLabel.text = moviesDetail?.releaseDate
        
        
        let url = URL(string: Api.imdbImageLink + (moviesDetail?.image)!)
        let processor = DownsamplingImageProcessor(size: moviesDetailImageView.bounds.size)
        
        moviesDetailImageView.kf.indicatorType = .activity
        moviesDetailImageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}

//MARK: - SmilarMoviesCollectionDataSource
extension MoviesDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        similarMoviesData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimilarMoviesCell", for: indexPath) as? SimilarMoviesCollectionViewCell {
            
            movieCell.configure(with: similarMoviesData[indexPath.row].movieTitle!, with: similarMoviesData[indexPath.row].image!)
            
            cell = movieCell
        }
        
        return cell
    }
}

//MARK: - SmilarMoviesCollectionDelegate
extension MoviesDetailViewController: UICollectionViewDelegate {
   
}

//MARK: - SmilarCollectionViewDelegateFlowLayout
extension MoviesDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = similarMoviesCollectionView.frame.size
        return CGSize(width: size.width / 3, height: size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

//MARK: - Segue Transfer
extension MoviesDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVc = segue.destination as? MoviesDetailViewController
        
        if segue.identifier == "similarMovieDetailSegue" {
        if let cell = sender as? UICollectionViewCell,
           let indexPath = self.similarMoviesCollectionView.indexPath(for: cell) {
                detailVc?.movieiD = similarMoviesData[indexPath.row].id
            }
        } else {
            
        }
        
        
    }
}
