//
//  MoviesTableViewController.swift
//  UIKitMovieApp
//
//  Created by renupunjabi on 8/27/23.
//

import UIKit

class MoviesTableViewController: UITableViewController {
    
    @IBOutlet var moviesList: UITableView!
    let viewModel = MovieSearchViewModel()
    
    var selectedMovie: Movie?
    
    var movies: [Movie] = [] {
        didSet {
            moviesList.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMovies()
    }
    
    private func fetchMovies() {
        Task {
            do {
                let result = try await viewModel.fetchMovieAsyncAwait("Titanic")

                DispatchQueue.main.async { [weak self] in
                    self?.movies = result
                }
            }
        }
    }
}

// TODO: UITableViewDataSource
extension MoviesTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as? MovieCell else { return UITableViewCell() }
        let movie = movies[indexPath.row]
        Task {
            do {
                let result = try await viewModel.getImage(movie.poster)
                DispatchQueue.main.async {
                    let image = UIImage(data: result)
                    cell.configure(movie, image: image)
                }
            }
        }
        return cell
    }
    
}

// TODO: UITableViewDelegate -- tap on cell and react
extension MoviesTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: "movieToDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "movieToDetail", let vc = segue.destination as? MovieDetailViewController {
            vc.movie = selectedMovie
            vc.viewModel = viewModel
        }
    }
    
}

