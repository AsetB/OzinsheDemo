//
//  MovieInfoViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 26.01.2024.
//

import UIKit
import Alamofire
import SwiftyJSON
import Localize_Swift
import SDWebImage
import SVProgressHUD

class MovieInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var seasonsButton: UIButton!
    @IBOutlet weak var seasonsArrow: UIImageView!
    @IBOutlet weak var addToFavoriteLabel: UILabel!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var TitleNameLabel: UILabel!
    @IBOutlet weak var SubTitleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var showFullDescriptionButton: UIButton!
    @IBOutlet weak var gradientViewOnBackggroundView: GradientView!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var directorNameLabel: UILabel!
    @IBOutlet weak var producerNameLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var screenshotsLabel: UILabel!
    @IBOutlet weak var screenshotsCollectionView: UICollectionView!
    @IBOutlet weak var similarLabel: UILabel!
    @IBOutlet weak var similarCollectionView: UICollectionView!
    
    var movie = Movie()
    var similarMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
        configureViews()
        downloadSimilar()
        navigationItem.title = " "
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        labelLocalize()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configureViews() {
        backgroundView.layer.cornerRadius = 32
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        descriptionLabel.numberOfLines = 3
        
        screenshotsCollectionView.delegate = self
        screenshotsCollectionView.dataSource = self
        
        if movie.movieType == "MOVIE" {
            seasonsButton.isHidden = true
            seasonsArrow.isHidden = true
            seriesLabel.isHidden = true
        } else {
            seasonsButton.setTitle("\(movie.seasonCount)" + "SEASON".localized() + "\(movie.seriesCount)" + "SERIES".localized(), for: .normal)
        }
        
        if descriptionLabel.maxNumberOfLines < 4 {
            showFullDescriptionButton.isHidden = true
        }
        
        if movie.favorite {
            favoriteButton.setImage(UIImage(named: "FavoriteButtonSelected"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(named: "FavoriteButtonEmpty"), for: .normal)
        }
        labelLocalize()
    }
    
    func labelLocalize() {
        addToFavoriteLabel.text = "ADD_FAVORITE".localized()
        shareLabel.text = "SHARE".localized()
        showFullDescriptionButton.setTitle("DETAILS".localized(), for: .normal)
        directorLabel.text = "DIRECTOR".localized()
        producerLabel.text = "PRODUCER".localized()
        seriesLabel.text = "SECTIONS".localized()
        screenshotsLabel.text = "SCREENSHOTS".localized()
        similarLabel.text = "SIMILAR_SERIES".localized()
        seasonsButton.setTitle("\(movie.seasonCount)" + "SEASON".localized() + "\(movie.seriesCount)" + "SERIES".localized(), for: .normal)
    }
    
    func setData() {
        posterImageView.sd_setImage(with: URL(string: movie.posterLink), completed: nil)
        TitleNameLabel.text = movie.name
        SubTitleLabel.text = "\(movie.year)"
        
        for i in movie.genres {
            SubTitleLabel.text = SubTitleLabel.text! + " • " + i.name
        }
        
        descriptionLabel.text = movie.description
        directorNameLabel.text = movie.director
        producerNameLabel.text = movie.producer
        
    }
    
    func downloadSimilar() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(URLs.GET_SIMILAR + String(movie.id), method: .get, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let array = json.array {
                    for item in array {
                        let movie = Movie(json: item)
                        self.similarMovies.append(movie)
                    }
                    self.similarCollectionView.reloadData()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR".localized())
                }
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }

    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playButton(_ sender: Any) {
        if movie.movieType == "MOVIE" {
            let playerViewController = storyboard?.instantiateViewController(withIdentifier: "MoviePlayerViewController") as! MoviePlayerViewController
            playerViewController.video_link = movie.videoLink
            navigationController?.show(playerViewController, sender: self)
        } else {
            let seasonsViewController = storyboard?.instantiateViewController(withIdentifier: "SeasonsSeriesViewController") as! SeasonsSeriesViewController
            seasonsViewController.movie = movie
            navigationController?.show(seasonsViewController, sender: self)
        }
    }
    
    @IBAction func addToFavoriteButton(_ sender: Any) {
        var method = HTTPMethod.post
        if movie.favorite {
            method = .delete
        }
        
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        let parameters = ["movieId": movie.id] as [String : Any]
        
        AF.request(URLs.FAVORITE_URL, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                
                self.movie.favorite.toggle()
                
                self.configureViews()
                
            } else {
                var ErrorString = "CONNECTION_ERROR".localized()
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let text = "\(movie.name) \n\(movie.description)"
        let image = posterImageView.image
        let shareAll = [text, image!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func showDescription(_ sender: Any) {
        if descriptionLabel.numberOfLines > 4 {
            descriptionLabel.numberOfLines = 4
            showFullDescriptionButton.setTitle("DETAILS".localized(), for: .normal)
            gradientViewOnBackggroundView.isHidden = false
        } else {
            descriptionLabel.numberOfLines = 30
            showFullDescriptionButton.setTitle("HIDE".localized(), for: .normal)
            gradientViewOnBackggroundView.isHidden = true
        }
    }
    
    //MARK: Image on tap
//    @objc func imageTapped(_ sender: UITapGestureRecognizer) {
//        let imageView = sender.view as! UIImageView
//        let newImageView = UIImageView(image: imageView.image)
//        newImageView.frame = UIScreen.main.bounds
//        newImageView.backgroundColor = .black
//        newImageView.contentMode = .scaleAspectFit
//        newImageView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
//        newImageView.addGestureRecognizer(tap)
//        self.view.addSubview(newImageView)
//        self.navigationController?.isNavigationBarHidden = true
//        self.tabBarController?.tabBar.isHidden = true
//    }
//
//    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
//        //self.navigationController?.isNavigationBarHidden = false
//        self.tabBarController?.tabBar.isHidden = false
//        sender.view?.removeFromSuperview()
//    }
    
    //MARK: Collection view
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.similarCollectionView {
            return similarMovies.count
        }
        return movie.screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.similarCollectionView {
            let similarCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            
            let transformer = SDImageResizingTransformer(size: CGSize(width: 112, height: 164), scaleMode: .aspectFill)
            
            let imageview = similarCell.viewWithTag(1000) as! UIImageView
            imageview.sd_setImage(with: URL(string: similarMovies[indexPath.row].posterLink), placeholderImage: nil, context: [.imageTransformer: transformer])
            imageview.layer.cornerRadius = 8
            
            
            let movieNameLabel = similarCell.viewWithTag(1001) as! UILabel
            movieNameLabel.text = similarMovies[indexPath.row].name
            
            let movieGenreNameLabel = similarCell.viewWithTag(1002) as! UILabel
            
            if let genrename = similarMovies[indexPath.row].genres.first {
                movieGenreNameLabel.text = genrename.name
            } else {
                movieGenreNameLabel.text = ""
            }
            
            return similarCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 184, height: 112), scaleMode: .aspectFill)
        
        let imageview = cell.viewWithTag(1000) as! UIImageView
        imageview.layer.cornerRadius = 8
        
        imageview.sd_setImage(with: URL(string: movie.screenshots[indexPath.row].link), placeholderImage: nil, context: [.imageTransformer: transformer])
        
//        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
//        imageview.addGestureRecognizer(pictureTap)
//        imageview.isUserInteractionEnabled = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.similarCollectionView {
            let movieinfoVC = storyboard?.instantiateViewController(withIdentifier: "MovieInfoViewController") as! MovieInfoViewController
            
            movieinfoVC.movie = similarMovies[indexPath.row]
            
            navigationController?.show(movieinfoVC, sender: self)
            
        }
        //logic to display screens

    }

}
