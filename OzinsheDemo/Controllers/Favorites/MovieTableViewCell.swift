//
//  MovieTableViewCell.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 21.11.2023.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var posterImageView: UIImageView!
  @IBOutlet weak var playView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 8
        playView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
  func setData(movie: Movie) {
      posterImageView.sd_setImage(with: URL(string: movie.posterLink), completed: nil)
      
      nameLabel.text = movie.name
      yearLabel.text = "\(movie.year)"
      
      for item in movie.genres {
          yearLabel.text = yearLabel.text! + " • " + item.name
      }
      
//      for item in movie.genres.filter({ $0.name.count <= 16 }) {
//          yearLabel.text = yearLabel.text! + " • " + item.name
//      }

//      for (index, item) in movie.genres.enumerated() {
//          if index < 2 {
//              yearLabel.text = yearLabel.text! + " • " + item.name
//          } else {
//              break
//          }
//      }
  }

}
