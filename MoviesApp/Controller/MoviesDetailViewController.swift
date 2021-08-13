//
//  MoviesDetailViewController.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 30.07.2021.
//

import UIKit

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
    var moviesDetail: Movies?
    var similarMoviesData: MoviesData?
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDelegate()
        configureDataSource()
        configureGetService()
        configureSetImageButton()
        navigationConfigure()
    }
    
    //MARK: - Configure Delegate
    func configureDelegate() {
        service.delegate = self
        similarMoviesCollectionView.delegate = self
    }
    
    //MARK: - Configure DataSource
    func configureDataSource() {
        similarMoviesCollectionView.dataSource = self
    }
    
    //MARK: - Configure GetService
    func configureGetService() {
        service.getMovieDetail(movieiD ?? 0) { detailMovies in
            self.moviesDetail = detailMovies
            self.configure()
        }
//        service.getSmilarMovies(movieiD ?? 0)
        service.getSmilarMovies(movieiD ?? 0) { similarMovies in
            self.similarMoviesData = similarMovies
            self.similarMoviesCollectionView.reloadData()
        }
    }
    
    //MARK: - Set ButtonImdb
    func configureSetImageButton() {
        let image = #imageLiteral(resourceName: "ImdbLogo")
        imdbButton.setBackgroundImage(image, for: .normal)
        imdbButton.addTarget(self, action: #selector(self.imdbButtonPressed(_:)), for: .touchUpInside)
    }
    
    //MARK: - ImdbButton Click Event
    @IBAction func imdbButtonPressed(_ sender: UIButton) {
        guard let imdb = moviesDetail?.imdb_id else { return }
        UIApplication.shared.openURL(URL(string: Api.imdbLink + imdb)!)
    }
    
    //MARK: - Configure Navigation
    func navigationConfigure() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Keywords.home, style: .done, target: self, action: #selector(goHomePage) )
    }
    
    //MARK: - Navigation Button Click Event
    @objc func goHomePage() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - ConfigureObjects
extension MoviesDetailViewController {
    
    func configure() {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = Date.dateFormatterGet
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = Date.dateFormatterPrint
        
        movieTitleLabel.text = moviesDetail?.title
        movieDescriptionLabel.text = moviesDetail?.overview
        movieAverageLabel.text = String(format: "%.1f", moviesDetail?.vote_average as! CVarArg)
        if let date = dateFormatterGet.date(from: (moviesDetail?.release_date ?? "")) {
            movieReleaseDateLabel.text = dateFormatterPrint.string(from: date)
        }
        Helper.setImage(with: Api.imdbImageLink + (moviesDetail?.backdrop_path ?? ""), with: moviesDetailImageView)
    }
}

//MARK: - Segue Transfer
extension MoviesDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVc = segue.destination as? MoviesDetailViewController
        
        
        if segue.identifier == Segue.similarMovieDetailSegue {
        if let cell = sender as? UICollectionViewCell,
           let indexPath = self.similarMoviesCollectionView.indexPath(for: cell) {
            detailVc?.movieiD = similarMoviesData?.results?[indexPath.row].id
            }
        }
    }
}

//MARK: - ServiceDelegate
extension MoviesDetailViewController: ServiceDelegate {
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - SmilarMoviesCollectionDataSource
extension MoviesDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        similarMoviesData?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let movieCell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.similarMoviesCell, for: indexPath) as? SimilarMoviesCollectionViewCell {
            
            movieCell.configure(with: similarMoviesData?.results?[indexPath.row].title ?? "", with: similarMoviesData?.results?[indexPath.row].backdrop_path ?? "")
            
            cell = movieCell
        }
        
        return cell
    }
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


