//
//  MovieDetailViewController.swift
//  UIKitMovieApp
//
//  Created by renupunjabi on 8/27/23.
//


import Foundation
import UIKit

class MovieDetailViewController: UIViewController {

    
    var movie: Movie?
    
    var viewModel: MovieSearchViewModel?
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        //parent view loading
        super.viewDidLoad()
        
        guard let movie = movie else { return }
    
            Task{
                do {
                    
                let result = try await viewModel?.getImage(movie.poster)
                DispatchQueue.main.async {
                    let image = UIImage(data: result!)
                    self.updateUI(image: image)
                }
                
            }
            
        }
    }
    private func updateUI (image: UIImage?) {
        titleLabel.text = movie?.title
        posterImageView.image = image
    }
}
