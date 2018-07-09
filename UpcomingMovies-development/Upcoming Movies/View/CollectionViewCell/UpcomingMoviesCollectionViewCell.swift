//
//  UpcomingMoviesCollectionViewCell.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 08/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import UIKit

class UpcomingMoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: CustomImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.autoresizingMask = [UIViewAutoresizing.flexibleHeight,UIViewAutoresizing.flexibleWidth]
        imageView.contentMode = .scaleAspectFill
        isUserInteractionEnabled = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
        imageView.alpha = CGFloat(0.5)
        imageView.backgroundColor = UIColor.darkGray
        self.isUserInteractionEnabled = false
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
        imageView.alpha = 1
        imageView.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
    }
}
