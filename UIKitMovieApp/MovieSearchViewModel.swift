//
//  MovieSearchViewModel.swift
//  MoviesApp
//
//  Created by renupunjabi on 4/26/23.
//

import Foundation
import Combine

class MovieSearchViewModel: ObservableObject {
    
    let service = MovieService()
    
    func fetchMovieAsyncAwait(_ name: String) async throws -> [Movie] {
        return try await service.fetchMovieAsyncAwait(name)
    }
    
    func getImage(_ urlString: String) async throws -> Data {
        return try await service.fetchImage(urlString)
    }
    
}
