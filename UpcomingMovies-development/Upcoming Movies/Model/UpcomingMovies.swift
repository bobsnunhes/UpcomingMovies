//
//  UpcomingMovies.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 07/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

struct UpcomingMovies: Codable {
    let results: [Result]
    let page, totalResults: Int
    let dates: Dates
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case results, page
        case totalResults = "total_results"
        case dates
        case totalPages = "total_pages"
    }
}

struct Dates: Codable {
    let maximum, minimum: String
}

struct Result: Codable {
    let voteCount, id: Int
    let video: Bool
    let voteAverage: Double
    let title: String
    let popularity: Double
    let posterPath: String?
    let originalLanguage: String?
    let originalTitle: String
    let genreIDS: [Int]?
    let backdropPath: String?
    let adult: Bool
    let overview, releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id, video
        case voteAverage = "vote_average"
        case title, popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult, overview
        case releaseDate = "release_date"
    }
}
