//
//  MoviePlayerViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 26.01.2024.
//

import UIKit
import YouTubePlayer

class MoviePlayerViewController: UIViewController {

    @IBOutlet weak var player: YouTubePlayerView!
    
    var video_link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        player.loadVideoID(video_link)

        // Do any additional setup after loading the view.
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
