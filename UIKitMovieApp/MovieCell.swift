//
//  MovieCell.swift
//  UIKitMovieApp
//
//  Created by renupunjabi on 8/27/23.
//

import Foundation
import UIKit

class MovieCell: UITableViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    func configure(_ movie: Movie, image: UIImage?) {
        movieImageView.image = image
        titleLabel.text = movie.title
        subtitleLabel.text = movie.year
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        subtitleLabel.text = ""
        movieImageView.image = nil
    }
    
}
