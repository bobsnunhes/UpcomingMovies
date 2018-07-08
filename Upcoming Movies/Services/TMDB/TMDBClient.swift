//
//  TMDBClient.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 07/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

class TMDBClient: NSObject {
    
    //MARK: Properties
    
    //Shared Session
    var session = URLSession.shared
    
    //MARK: Initializers
    override init() {
        super.init()
    }
    
    //MARK: GET Method
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completion: @escaping(_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var parameterWithAPIKey = parameters
        parameterWithAPIKey[ParameterKeys.ApiKey]  = Constants.ApiKey as AnyObject?
        
        let task = session.dataTask(with: tmdbURLBuilder(parameterWithAPIKey, withPathExtenstion: method)) { (data, response, error) in
            
            guard let data = data else { return }
            
            let dataAsString = String(data: data, encoding: .utf8)
            
            print(dataAsString)
            
        }
        
        task.resume()
        
        return task
        
        
    }
    
    //MARK: TMDB URL Builder
    private func tmdbURLBuilder(_ parameters: [String:AnyObject], withPathExtenstion: String? = nil) -> URL {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = TMDBClient.Constants.ApiScheme
        urlComponents.host = TMDBClient.Constants.ApiHost
        urlComponents.path = TMDBClient.Constants.ApiPath + (withPathExtenstion ?? "")
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems!.append(queryItem)
        }
        
        return urlComponents.url!
    }
    
    //MARK: TMDB Service Singleton
    class func sharedInstance() -> TMDBClient {
        struct Singleton {
            static var sharedInstance = TMDBClient()
        }
        return Singleton.sharedInstance
    }
}
