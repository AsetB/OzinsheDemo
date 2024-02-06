//
//  SeasonsSeriesViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 26.01.2024.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON
import SDWebImage
import Localize_Swift
import YouTubePlayerKit

class SeasonsSeriesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var movie = Movie()
    var seasons: [Season] = []
    var currentSeason = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        downloadSeason()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "SECTIONS".localized()
    }
    
    func downloadSeason() {
        SVProgressHUD.show()
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Storage.sharedInstance.accessToken)"
        ]
        
        AF.request(URLs.GET_SEASONS + String(movie.id), method: .get, headers: headers).responseData { response in
            
            print("\(String(describing: response.request))")  // original URL request
            print("\(String(describing: response.request?.allHTTPHeaderFields))")  // all HTTP Header Fields
            print("\(String(describing: response.response))") // HTTP URL response
            print("\(String(describing: response.data))")     // server data
            print("\(response.result)")   // result of response serialization
            print("\(String(describing: response.value))")   // result of response serialization
            
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
                        let season = Season(json: item)
                        self.seasons.append(season)
                    }
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
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
    
    // MARK: Collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return seasons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let seasonLabel = cell.viewWithTag(1001) as! UILabel
        seasonLabel.text = "\(seasons[indexPath.row].number)" + "SEASON_IN_SERIES".localized()
        
        let backgroundView = cell.viewWithTag(1000)!
        backgroundView.layer.cornerRadius = 8
        
        if currentSeason == seasons[indexPath.row].number - 1 {
            seasonLabel.textColor = UIColor(red: 249/255, green: 250/255, blue: 251/255, alpha: 1)
            backgroundView.backgroundColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1)
        } else {
            seasonLabel.textColor = UIColor(red: 55/255, green: 65/255, blue: 81/255, alpha: 1)
            backgroundView.backgroundColor = UIColor(red: 243/255, green: 244/255, blue: 246/255, alpha: 1)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        currentSeason = seasons[indexPath.row].number - 1
        tableView.reloadData()
        collectionView.reloadData()
    }
    
    // MARK: Table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if seasons.isEmpty {
            return 0
        }
        return seasons[currentSeason].videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let seriesNumberLabel = cell.viewWithTag(1001) as! UILabel
        seriesNumberLabel.text = "\(seasons[currentSeason].videos[indexPath.row].number)" + "EPISODE".localized()
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 345, height: 178), scaleMode: .aspectFill)
        let imageView = cell.viewWithTag(1000) as! UIImageView
        imageView.layer.cornerRadius = 12
        imageView.sd_setImage(with: URL(string: "https://img.youtube.com/vi/\(seasons[currentSeason].videos[indexPath.row].link)/hqdefault.jpg"), placeholderImage: nil, context: [.imageTransformer : transformer])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let youTubePlayerViewController = YouTubePlayerViewController(
            player: ""
        )
        youTubePlayerViewController.player.source = .video(id: seasons[currentSeason].videos[indexPath.row].link, startSeconds: nil, endSeconds: nil)
        youTubePlayerViewController.player.configuration = .init(
            fullscreenMode: .system, autoPlay: true, showControls: true, showFullscreenButton: true, useModestBranding: false, playInline: false, showRelatedVideos: false)
        self.show(youTubePlayerViewController, sender: self)
//        let playerViewController = storyboard?.instantiateViewController(withIdentifier: "MoviePlayerViewController") as! MoviePlayerViewController
//        playerViewController.video_link = seasons[currentSeason].videos[indexPath.row].link
//        navigationController?.show(playerViewController, sender: self)
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
