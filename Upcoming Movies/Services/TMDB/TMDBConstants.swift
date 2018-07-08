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
        static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
        static let AccountURL = "https://www.themoviedb.org/account/"
        
    }
}
