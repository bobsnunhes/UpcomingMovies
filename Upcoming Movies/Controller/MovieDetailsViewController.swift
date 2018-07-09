//
//  MovieDetailsViewController.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 08/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var visualFX: UIVisualEffectView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var voteAverage: UILabel!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieOverview: UITextView!
    @IBOutlet weak var releaseDate: UILabel!
    
    
    
    var selectedMovie: Result?
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    let unwindToUpcomingMoviesSegue = "returnToUpcomingMoviesSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFill
        
        getBackgroundImage()
        
        if let movie = selectedMovie {
            voteAverage.text = "\(movie.voteAverage)"
            movieTitle.text = movie.title
            movieOverview.text = movie.overview
            releaseDate.text = movie.releaseDate
        }
    }
    
    func getBackgroundImage() {
        if let movie = selectedMovie {
            activityIndicator.startAnimating()
            let _ = TMDBClient.sharedInstance().taskForGetImage(SharedManager.shared.tmdbDefaultPosterSize!, filePath: movie.posterPath!) { (imageData, error) in
                if let error = error  {
                    debugPrint("Error while trying to get image tumbnail for movie. Error: \(error.localizedDescription)")
                } else {
                    if let image = UIImage(data: imageData!) {
                        DispatchQueue.main.async {
                            let imageToCache = image
                            
                            self.imageCache.setObject(imageToCache, forKey: movie.posterPath as AnyObject)
                            
                            self.imageView.image = imageToCache
                            self.activityIndicator.stopAnimating()
                        }
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func backToUpcomingMovies(_ sender: Any) {
        performSegue(withIdentifier: unwindToUpcomingMoviesSegue, sender: nil)
    }
}
