//
//  TMDBConvenience.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 08/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

extension TMDBClient {
    
    //MARK: Get Images Configuration
    func getImagesConfiguration(_ completion: @escaping (_ result: TMDBConfig?, _ error: Error?) ->Void) {
        
        let parameters : [String:AnyObject] = [:]
        
        let method: String = Methods.ImageConfiguration
        
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]) { (results, error) in
            if let error = error {
                completion(nil, error)
            } else {
                guard let results = results else {
                    debugPrint("Error while trying to get the images configuration.")
                    return
                }
                
                do {
                    let imagesConfiguration = try JSONDecoder().decode(TMDBConfig.self, from: results)
                    
                    if imagesConfiguration.images.baseURL != "" {
                        completion(imagesConfiguration, nil)
                    }
                } catch let jsonError {
                    debugPrint("Error while trying to decoder JSON to Images Configuration struct. Error: \(jsonError)")
                    completion(nil,jsonError)
                }
            }
        }
    }
    
    //MARK: Get Upcoming Movies
    func getUpcomingMovies(page: Int = 1,_ completion: @escaping (_ result: UpcomingMovies?, _ error: Error?) -> Void) {
        
        let parameters = [TMDBClient.URLKeys.Page : page]
        
        let method: String = Methods.UpcomingMovies
        
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]) { (results, error) in
            if let error = error {
                completion(nil, error)
            } else {
                guard let results = results else {
                    debugPrint("Error while trying to get the Upcoming Movies results.")
                    return
                }
                
                do {
                    let upcomingMovies = try JSONDecoder().decode(UpcomingMovies.self, from: results)
                    
                    if upcomingMovies.results.count > 0 {
                        completion(upcomingMovies, nil)
                    } 
                } catch let jsonError {
                    debugPrint("Error while trying to decoder JSON to Upcoming Movies struct. Error: \(jsonError)")
                    completion(nil,jsonError)
                }
                
            
            }
        }
        
    }
}
