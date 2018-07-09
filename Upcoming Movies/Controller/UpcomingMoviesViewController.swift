//
//  UpcomingMoviesViewController.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 07/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import UIKit

class UpcomingMoviesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelActivityIndicator: UILabel!
    
    let cellID = "upcomingMovieCellID"
    let movieDetailsSegue = "movieDetailsSegue"
    var upcomingMovies: UpcomingMovies?
    var results: [Result]?
    var selectedMovie: Result?
    var imagesConfiguration: TMDBConfig?
    
    var cellWidthPortrait: CGFloat?
    var cellWidthLandscape: CGFloat?
    
    var cellHeightPortrait: CGFloat?
    var cellHeightLandscape: CGFloat?
    
    var fetchingMore = false
    
    var currentPage = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelActivityIndicator.isHidden = true
        labelActivityIndicator.isUserInteractionEnabled = false
        
        setupCollectionView()
        
        getImagesConfiguration()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        setCollectionViewSizeByOrientation()
    }
    
    func setCollectionViewSizeByOrientation() {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        cellWidthPortrait = (screenWidth - 10) / 2
        cellHeightPortrait = cellWidthPortrait! * 1.5
        
        cellWidthLandscape = (screenWidth - 10) / 4
        cellHeightLandscape = cellWidthLandscape! * 1.5
        
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            //Landscape
            flowLayout.itemSize = CGSize(width: cellWidthLandscape!, height: cellHeightLandscape!)
        } else {
            //Portrait
            flowLayout.itemSize = CGSize(width: cellWidthPortrait!, height: cellHeightPortrait!)
        }
        
        flowLayout.invalidateLayout()
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "UpcomingMoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
    }
    
    func getImagesConfiguration() {
        func setImageConfigs(imageConfig: TMDBConfig) {
            self.imagesConfiguration = imageConfig
            SharedManager.shared.tmdbImageConfiguration = self.imagesConfiguration
            SharedManager.shared.tmdbDefaultTumbPosterSize = self.imagesConfiguration?.images.posterSizes[3]
            SharedManager.shared.tmdbDefaultPosterSize = self.imagesConfiguration?.images.posterSizes[4]
            SharedManager.shared.tmdbBaseURLString = self.imagesConfiguration?.images.secureBaseURL
            
            getUpcomingMovies()
        }
        
        func startLoading() {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.labelActivityIndicator.isHidden = false
                self.labelActivityIndicator.text = "Carregando configuração inicial..."
            }
        }
        
        func stopLoading() {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.labelActivityIndicator.isHidden = true
            }
        }
        
        startLoading()
        if let savedImagesConfig = SharedManager.shared.getUsersImageConfig() {
            stopLoading()
            setImageConfigs(imageConfig: savedImagesConfig)
        } else {
            TMDBClient.sharedInstance().getImagesConfiguration { (imagesConfiguration, error) in
                if let error = error {
                    debugPrint("Error while trying to get the images configuration. Error: \(error.localizedDescription)")
                } else {
                    stopLoading()
                    setImageConfigs(imageConfig: imagesConfiguration!)
                }
            }
        }
    }
    
    func getUpcomingMovies() {
        TMDBClient.sharedInstance().getUpcomingMovies(page: 1) { (upcomingMoviesResponse, error) in
            if let error = error {
                debugPrint("Error while trying to get the last upcoming movies. Error: \(error.localizedDescription)")
            } else {
                self.upcomingMovies = upcomingMoviesResponse
                self.results = self.upcomingMovies?.results
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func getMoreMovies() {
        if (upcomingMovies?.totalPages)! > currentPage {
            currentPage += 1
            
            TMDBClient.sharedInstance().getUpcomingMovies(page: currentPage) { (upcomingMoviesResponse, error) in
                if let error = error {
                    debugPrint("Error while trying to get more movies. Error: \(error.localizedDescription)")
                } else {
                    self.fetchingMore = false
                    if let movies = upcomingMoviesResponse {
                        for result in movies.results {
                            DispatchQueue.main.async {
                                self.results?.append(result)
                                self.collectionView.reloadData()
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func returnToUpcomingMovies(unwindSegue: UIStoryboardSegue) {
        print(unwindSegue.identifier ?? "Nenhum segue")
    }
}

extension UpcomingMoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let result = results?[indexPath.row] {
            selectedMovie = result
            performSegue(withIdentifier: movieDetailsSegue, sender: result)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == movieDetailsSegue {
            if let selectedMovie = sender as? Result {
                if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
                    movieDetailsViewController.selectedMovie = selectedMovie
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! UpcomingMoviesCollectionViewCell
    
        if cell.imageView.image == nil {
            if let posterPath = results?[indexPath.row].posterPath {
                if let imageFromCache = imageCache.object(forKey: posterPath as AnyObject) as? UIImage {
                    cell.imageView.image = imageFromCache
                    cell.stopLoading()
                } else {
                    if let baseURL = SharedManager.shared.tmdbBaseURLString, baseURL != "" {
                        cell.startLoading()
                        cell.imageView.loadImageUsingUrlString(urlString: posterPath) { (image, error) in
                            if let error = error {
                                debugPrint("Error while trying to get image tumbnail for movie. Error: \(error.localizedDescription)")
                            } else {
                                DispatchQueue.main.async {
                                    cell.stopLoading()
                                }
                            }
                        }
                    }
                }
            } else {
                debugPrint("posterPath = \(results?[indexPath.row].posterPath)")
                debugPrint("backdropPath = \(results?[indexPath.row].backdropPath)")
                debugPrint("Title = \(results?[indexPath.row].title)")
            }
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = true
        
        getMoreMovies()
    }
}

