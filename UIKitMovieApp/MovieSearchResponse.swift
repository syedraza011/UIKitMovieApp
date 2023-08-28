//
//  File.swift
//  MoviesApp
//
//  Created by renupunjabi on 4/26/23.
//

import Foundation

struct MovieSearchResponse: Codable {
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "Search"
    }
}
    
struct Movie: Codable, Identifiable, Hashable {
    let id: String
    let title: String
    let year: String
    let type: String
    let poster: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "imdbID"
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case type = "Type"
        
    }
}
