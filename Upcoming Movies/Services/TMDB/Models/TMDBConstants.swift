//
//  TMDBConstants.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 07/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

extension TMDBClient {
    
    //MARK: Constants
    struct Constants {
        
        //MARK: API KEY
        static let ApiKey = "1f54bd990f1cdfb230adb312546d765d"
        
        //MARK: URL
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
    }
    
    //MARK: Methods
    struct Methods {
        static let ImageConfiguration = "/configuration"
        static let UpcomingMovies = "/movie/upcoming"
    }
    
    //MARK: Parameter Keys
    struct ParameterKeys {
        static let ApiKey = "api_key"
    }
    
    //MARK: URL Keys
    struct URLKeys {
        static let Page = "page"
    }
}
