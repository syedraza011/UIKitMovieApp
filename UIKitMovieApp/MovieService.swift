//
//  MovieService.swift
//  MoviesApp
//
//  Created by renupunjabi on 4/26/23.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case serviceError
}

protocol MovieServiceProtocol {
    func fetchMovie(_ name: String) -> Future<[Movie], Error>
    
    func fetchMovieAsyncAwait(_ name: String) async throws -> [Movie]
}

final class MovieService: MovieServiceProtocol {
    var cancellables = Set<AnyCancellable>()
    
    private func createUrl(for name: String) -> URL? {
        var request = URLComponents(string: Constants.baseUrl)
        request?.queryItems = [
            URLQueryItem(name: "apiKey", value: Constants.apiKey),
            URLQueryItem(name: "s", value: name)
        ]
        return request?.url
    }
    
    //https://www.omdbapi.com/?apikey=e41e1c08&s=titanic
    func fetchMovie(_ name: String) -> Future<[Movie], Error> {
        
        return Future {[weak self] promise in
            guard let self = self, let url = self.createUrl(for: name) else {
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: MovieSearchResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink { responseError in
                    switch responseError {
                    case .failure(let err):
                        promise(.failure(err))
                    case .finished:
                        break
                    }
                } receiveValue: { response in
                    promise(.success(response.movies))
                }
                .store(in: &self.cancellables)
        }
                
    }
    
    func fetchMovieAsyncAwait(_ name: String) async throws -> [Movie] {
        
        guard let url = createUrl(for: name) else { throw APIError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let status = (response as? HTTPURLResponse)?.statusCode, 200...299 ~= status else {
            throw APIError.serviceError
        }
        
        let movieResponse = try JSONDecoder().decode(MovieSearchResponse.self, from: data)
        return movieResponse.movies
    }
    
    func fetchImage(_ urlString: String) async throws -> Data {
        guard !urlString.isEmpty, let url = URL(string: urlString) else { throw APIError.invalidURL }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let status = (response as? HTTPURLResponse)?.statusCode, 200...299 ~= status else {
            throw APIError.serviceError
        }
        return data
    }
    
    
    
}
