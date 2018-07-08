//
//  TMDBConvenience.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 08/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

extension TMDBClient {
    
    //MARK: Get Upcoming Movies
    func getUpcomingMovies(page: Int = 1,_ completion: @escaping (_ result: UpcomingMovies?, _ error: NSError?) -> Void) {
        
        let parameters = [TMDBClient.ParameterKeys.Page : page]
        
        let method: String = Methods.UpcomingMovies
        
        let _ = taskForGETMethod(method, parameters: parameters as [String:AnyObject]) { (results, error) in
            if let error = error {
                completion(nil, error)
            } else {
                let string = String(data: results as! Data, encoding: .utf8)
                
                print("ai sim \(string)")
            
            }
        }
        
    }
}
