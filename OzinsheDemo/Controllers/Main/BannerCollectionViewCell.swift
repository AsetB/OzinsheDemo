//
//  BannerCollectionViewCell.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 18.01.2024.
//

import UIKit
import SDWebImage

class BannerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerCategoryView: UIView!
    @IBOutlet weak var bannerCategoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bannerCategoryView.layer.cornerRadius = 8
        bannerImageView.layer.cornerRadius = 12
    }
    
    func setData(bannerMovie: BannerMovie) {
        let transformer = SDImageResizingTransformer(size: CGSize(width: 300, height: 164), scaleMode: .aspectFill)
        bannerImageView.sd_setImage(with: URL(string: bannerMovie.link), placeholderImage: nil, context: [.imageTransformer : transformer])
        if let categoryName = bannerMovie.movie.categories.first?.name {
            bannerCategoryLabel.text = categoryName
        }
        titleLabel.text = bannerMovie.movie.name
        descriptionLabel.text = bannerMovie.movie.description
    }
}
