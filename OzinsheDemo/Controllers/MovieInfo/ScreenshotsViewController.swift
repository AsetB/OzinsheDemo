//
//  ScreenshotsViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 31.01.2024.
//

import UIKit
import SDWebImage


class ScreenshotsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageScrollView: ImageScrollView!
    
    var movie = Movie()
    var selectedScreenshotIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
//        imageScrollView.setup()
//        let myImage = UIImage(named: "firstSlide")
//        imageScrollView.display(image: myImage!)
        // Do any additional setup after loading the view.
        if let index = selectedScreenshotIndex {
            let indexPath = IndexPath(item: index, section: 0)
            collectionView.reloadData()
            collectionView.layoutIfNeeded()
            guard let rect = self.collectionView.layoutAttributesForItem(at: indexPath)?.frame else { return }
            self.collectionView.scrollRectToVisible(rect, animated: false)
        }
    }
    
    func setData(movie: Movie) {
        self.movie = movie
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movie.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.viewWithTag(1000) as! UIImageView
        imageView.sd_setImage(with: URL(string: movie.screenshots[indexPath.row].link), placeholderImage: nil)
        //let transformer = SDImageResizingTransformer(size: CGSize(width: 393, height: 240), scaleMode: .aspectFill)
        //imageView.sd_setImage(with: URL(string: movie.screenshots[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
        imageView.enableZoom()
        imageView.enableDoubleTapZoom()
   
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

}
