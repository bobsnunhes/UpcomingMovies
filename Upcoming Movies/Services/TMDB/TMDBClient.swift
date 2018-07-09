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
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completion: @escaping(_ result: Data?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        var parameterWithAPIKey = parameters
        parameterWithAPIKey[ParameterKeys.ApiKey]  = Constants.ApiKey as AnyObject?
        
        let task = session.dataTask(with: tmdbURLBuilder(parameterWithAPIKey, withPathExtenstion: method)) { (data, response, error) in
            
            if let error = error {
                completion(nil, error)
            } else {
                
                self.urlResponseStatusChecker(response: response)
            
                guard let data = data else {
                    debugPrint("Error while trying to get data")
                    return
                }
                
                completion(data, nil)
            }
        }
        
        task.resume()
        
        return task
    }
    
    //MARK: GET Image
    func taskForGetImage(_ size: String, filePath: String, completion: @escaping (_ imageData: Data?, _ error: Error?) -> Void) -> URLSessionTask? {

        if SharedManager.shared.tmdbBaseURLString == nil {
            getImagesConfiguration { (imagesConfig, error) in
                if let error = error {
                    debugPrint("Error while trying to get images config from taskForGetImage method. Error: \(error.localizedDescription)")
                } else {
                    SharedManager.shared.tmdbImageConfiguration = imagesConfig
                    SharedManager.shared.saveImageConfigToUserDefaults()
                    
                    _ = self.taskForGetImage(size, filePath: filePath, completion: { (data, error) in
                        if let error = error {
                            completion(nil, error)
                        } else {
                            completion(data, nil)
                        }
                    })
                }
            }
        } else {
            let baseURL = URL(string: SharedManager.shared.tmdbBaseURLString!)!
            let url = baseURL.appendingPathComponent(size).appendingPathComponent(filePath)
            
            let request = URLRequest(url: url)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    self.urlResponseStatusChecker(response: response)
                    
                    guard let data = data else {
                        debugPrint("Error while trying to get image for URL: \(url.absoluteString)")
                        return
                    }
                    
                    completion(data, nil)
                }
            }
            
            task.resume()
            
            return task
        }
        
        return nil
        
    }
    
    //MARK: URLResponse Status Checker
    private func urlResponseStatusChecker(response: URLResponse?) {
        guard let response = response else {
            print("Erro ao buscar response.")
            return
        }
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode <= 299 else {
            print("Erro ao buscar status code.")
            return
        }
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
