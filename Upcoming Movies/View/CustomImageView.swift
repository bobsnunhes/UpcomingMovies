//
//  CustomImageView.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 08/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import UIKit
import Foundation

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String,_ completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        
        imageUrlString = urlString
    
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        let _ = TMDBClient.sharedInstance().taskForGetImage(SharedManager.shared.tmdbDefaultTumbPosterSize!, filePath: imageUrlString!) { (imageData, error) in
            if let error = error  {
                debugPrint("Error while trying to get image tumbnail for movie. Error: \(error.localizedDescription)")
                completion(nil, error)
            } else {
                if let image = UIImage(data: imageData!) {
                    DispatchQueue.main.async {
                        let imageToCache = image
                        
                        if self.imageUrlString == urlString {
                            self.image = imageToCache
                        }
                        
                        imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                        completion(image, nil)
                    }
                }
            }
        }
    }
    
}
