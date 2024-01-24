//
//  MainTableViewCell.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 15.01.2024.
//

import UIKit
import SDWebImage
import Localize_Swift

class MainTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
        
    @IBOutlet weak var mainLabel: UILabel!//categoryNameLabel
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mainMovie = MainMovies()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize.width = 112
        layout.estimatedItemSize.height = 220
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(mainMovie: MainMovies) {
        mainLabel.text = mainMovie.categoryName
        secondLabel.text = "ALL".localized()
        self.mainMovie = mainMovie
        collectionView.reloadData()
    }
    
    //MARK: Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainMovie.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 112, height: 164), scaleMode: .aspectFill)
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.sd_setImage(with: URL(string: mainMovie.movies[indexPath.row].posterLink), placeholderImage: nil, context: [.imageTransformer : transformer])
        imageview.layer.cornerRadius = 8
        
        let movieNamelabel = cell.viewWithTag(1001) as! UILabel
        movieNamelabel.text = mainMovie.movies[indexPath.row].name
        
        let movieGenreNameLabel = cell.viewWithTag(1002) as! UILabel
        if let genreName = mainMovie.movies[indexPath.row].genres.first {
            movieGenreNameLabel.text = genreName.name
        } else {
            movieGenreNameLabel.text = ""
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
//        
//        let categoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "CategoryTableViewController") as! CategoryTableViewController
//        categoryTableViewController.categoryID = categories[indexPath.row].id
//        categoryTableViewController.categoryName = categories[indexPath.row].name
//        
//        navigationController?.show(categoryTableViewController, sender: self)
    }

}

open class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }
        guard layoutAttributes.representedElementCategory == .cell else { return layoutAttributes }
        
        func layoutAttributesForRow() -> [UICollectionViewLayoutAttributes]? {
            guard let collectionView = collectionView else { return [layoutAttributes] }
            let contentWidth = collectionView.frame.size.width - sectionInset.left - sectionInset.right
            var rowFrame = layoutAttributes.frame
            rowFrame.origin.x = sectionInset.left
            rowFrame.size.width = contentWidth
            return super.layoutAttributesForElements(in: rowFrame)
        }
        
        let minYs = minimumYs(from: layoutAttributesForRow())
        guard let minY = minYs[layoutAttributes.indexPath] else { return layoutAttributes }
        layoutAttributes.frame = layoutAttributes.frame.offsetBy(dx: 0, dy: minY - layoutAttributes.frame.origin.y)
        return layoutAttributes
    }
    
    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?
            .map { $0.copy() } as? [UICollectionViewLayoutAttributes]
        
        let minimumYs = minimumYs(from: attributes)
        attributes?.forEach {
            guard $0.representedElementCategory == .cell else { return }
            guard let minimumY = minimumYs[$0.indexPath] else { return }
            $0.frame = $0.frame.offsetBy(dx: 0, dy: minimumY - $0.frame.origin.y)
        }
        return attributes
    }
    
    /// Returns the minimum Y values based for each index path.
    private func minimumYs(from layoutAttributes: [UICollectionViewLayoutAttributes]?) -> [IndexPath: CGFloat] {
        layoutAttributes?
            .reduce([CGFloat: (CGFloat, [UICollectionViewLayoutAttributes])]()) {
                guard $1.representedElementCategory == .cell else { return $0 }
                return $0.merging([ceil($1.center.y): ($1.frame.origin.y, [$1])]) {
                    ($0.0 < $1.0 ? $0.0 : $1.0, $0.1 + $1.1)
                }
            }
            .values.reduce(into: [IndexPath: CGFloat]()) { result, line in
                line.1.forEach { result[$0.indexPath] = line.0 }
            } ?? [:]
    }
}
