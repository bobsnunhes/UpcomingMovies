//
//  TMDBConfig.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 08/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

struct TMDBConfig: Codable {
    let images: Images
    let changeKeys: [String]
    
    enum CodingKeys: String, CodingKey {
        case images
        case changeKeys = "change_keys"
    }
}

struct Images: Codable {
    let baseURL, secureBaseURL: String
    let backdropSizes, logoSizes, posterSizes, profileSizes: [String]
    let stillSizes: [String]
    
    enum CodingKeys: String, CodingKey {
        case baseURL = "base_url"
        case secureBaseURL = "secure_base_url"
        case backdropSizes = "backdrop_sizes"
        case logoSizes = "logo_sizes"
        case posterSizes = "poster_sizes"
        case profileSizes = "profile_sizes"
        case stillSizes = "still_sizes"
    }
}
