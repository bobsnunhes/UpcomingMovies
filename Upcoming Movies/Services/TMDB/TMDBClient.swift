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
    
    //Authentication
    var requestToken: String? = nil
    var sessionID: String? = nil
    var userID: Int? = nil
    
    //MARK: Initializers
    override init() {
        super.init()
    }
    
    
}
