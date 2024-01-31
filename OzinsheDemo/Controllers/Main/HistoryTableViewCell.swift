//
//  HistoryTableViewCell.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 18.01.2024.
//

import UIKit
import SDWebImage
import Localize_Swift

class HistoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mainMovies = MainMovies()
    weak var delegate: MovieProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(mainMovie: MainMovies) {
        self.mainMovies = mainMovie
        titleLabel.text = "CONTINUE_PLAY".localized()
        collectionView.reloadData()
    }

    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMovies.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.sd_setImage(with: URL(string: mainMovies.movies[indexPath.row].posterLink), placeholderImage: nil, context: [.imageTransformer : transformer])
        imageview.layer.cornerRadius = 8
        
        let titleLabel = cell.viewWithTag(1001) as! UILabel
        titleLabel.text = mainMovies.movies[indexPath.row].name
        let genreLabel = cell.viewWithTag(1002) as! UILabel
        if let genreName = mainMovies.movies[indexPath.row].genres.first {
            genreLabel.text = genreName.name
        } else {
            genreLabel.text = ""
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.movieDidSelect(movie: mainMovies.movies[indexPath.row])
    }
}
