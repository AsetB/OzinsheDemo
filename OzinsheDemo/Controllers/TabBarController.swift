//
//  TabBarController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 17.11.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setTabImages()
    }
  
  func setTabImages() {
    let homeSelectedImage = UIImage(named: "HomeSelected")?.withRenderingMode(.alwaysOriginal)
    let searchSelectedImage = UIImage(named: "SearchSelected")?.withRenderingMode(.alwaysOriginal)
    let favoriteSelectedImage = UIImage(named: "FavoriteSelected")?.withRenderingMode(.alwaysOriginal)
    let profileSelectedImage = UIImage(named: "ProfileSelected")?.withRenderingMode(.alwaysOriginal)
    
    tabBar.items?[0].selectedImage = homeSelectedImage
    tabBar.items?[1].selectedImage = searchSelectedImage
    tabBar.items?[2].selectedImage = favoriteSelectedImage
    tabBar.items?[3].selectedImage = profileSelectedImage
    
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
