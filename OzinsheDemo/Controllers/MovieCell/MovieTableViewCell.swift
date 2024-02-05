//
//  MovieTableViewCell.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 21.11.2023.
//

import UIKit
import SDWebImage
import Localize_Swift

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var playLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImageView.layer.cornerRadius = 8
        playView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
  
  func setData(movie: Movie) {
      posterImageView.sd_setImage(with: URL(string: movie.posterLink), completed: nil)
      
      nameLabel.text = movie.name
      yearLabel.text = "\(movie.year)"
      playLabel.text = "PLAY".localized()
      
      for item in movie.genres {
          yearLabel.text = yearLabel.text! + " • " + item.name
      }
  }

}
