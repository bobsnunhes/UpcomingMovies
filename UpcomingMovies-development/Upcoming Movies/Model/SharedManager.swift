//
//  SharedManager.swift
//  Upcoming Movies
//
//  Created by roberto fernandes filho on 08/07/2018.
//  Copyright © 2018 Betocorporation. All rights reserved.
//

import Foundation

//Singleton
class SharedManager {
    private init() {}
    
    static let shared = SharedManager()
    
    private let defaults = UserDefaults.standard
    private let userImageConfigKey = "SavedImageConfig"

    var tmdbImageConfiguration: TMDBConfig?
    var tmdbDefaultTumbPosterSize: String?
    var tmdbDefaultPosterSize: String?
    var tmdbBaseURLString: String? 
    
    func saveImageConfigToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tmdbImageConfiguration) {
            defaults.set(encoded, forKey: userImageConfigKey)
        }
    }
    
    func getUsersImageConfig() -> TMDBConfig? {
        if let imageConfig = defaults.object(forKey: userImageConfigKey) as? Data {
            let decoder = JSONDecoder()
            if let loadedImageConfig = try? decoder.decode(TMDBConfig.self, from: imageConfig) {
                return loadedImageConfig
            }
        }
        return nil
    }
}
