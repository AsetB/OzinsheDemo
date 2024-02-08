//
//  GenreAgeTableViewCell.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 18.01.2024.
//

import UIKit
import SDWebImage
import Localize_Swift

class GenreAgeTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    weak var delegate: MovieProtocol?
    var mainMovies = MainMovies()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(mainMovie: MainMovies) {
        self.mainMovies = mainMovie
        if mainMovies.cellType == .ageCategory {
            titleLabel.text = "AGE_CATEGORY".localized()
        } else {
            titleLabel.text = "CHOOSE_GENRE".localized()
        }
        collectionView.reloadData()
    }

    //MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if mainMovies.cellType == .ageCategory {
            return mainMovies.categoryAges.count
        }
        return mainMovies.genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.layer.cornerRadius = 8
        
        let nameLabel = cell.viewWithTag(1001) as! UILabel
        
        if mainMovies.cellType == .ageCategory {
            imageview.sd_setImage(with: URL(string: mainMovies.categoryAges[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer : transformer])
            nameLabel.text = mainMovies.categoryAges[indexPath.row].name
        } else {
            imageview.sd_setImage(with: URL(string: mainMovies.genres[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer : transformer])
            nameLabel.text = mainMovies.genres[indexPath.row].name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if mainMovies.cellType == .ageCategory {
            delegate?.ageDidSelect(ageID: mainMovies.categoryAges[indexPath.row].id, ageName: mainMovies.categoryAges[indexPath.row].name)
        } else {
            delegate?.genreDidSelect(genreID: mainMovies.genres[indexPath.row].id, genreName: mainMovies.genres[indexPath.row].name)
        }
        
    }
}
