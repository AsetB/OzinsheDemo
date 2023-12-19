//
//  ProfileViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 15.12.2023.
//

import UIKit
import Localize_Swift

class ProfileViewController: UIViewController, LanguageProtocol {
    
    @IBOutlet weak var myProfileLabel: UILabel!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var languageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override func viewDidAppear(_ animated: Bool) {
        
//        if Localize.currentLanguage() == "ru" {
//            languageLabel.text = "Русский"
//        }
//        if Localize.currentLanguage() == "en" {
//            languageLabel.text = "English"
//        }
//        if Localize.currentLanguage() == "kk" {
//            languageLabel.text = "Қазақша"
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
      configureViews()
    }
    
    func configureViews() {
        myProfileLabel.text = "MY_PROFILE".localized()
        languageButton.setTitle("LANGUAGE".localized(), for: .normal)
        
        switch Localize.currentLanguage() {
        case "ru": languageLabel.text = "Русский"
        case "en": languageLabel.text = "English"
        case "kk": languageLabel.text = "Қазақша"
        default: languageLabel.text = "Қазақша"
        }
    }
    
    @IBAction func languageShow(_ sender: Any) {
        let languageVC = storyboard?.instantiateViewController(withIdentifier: "LanguageViewController") as! LanguageViewController
        languageVC.modalPresentationStyle = .overFullScreen
        languageVC.delegate = self
        
        present(languageVC, animated: true, completion: nil)
    }
    
    func languageDidChange() {
        configureViews()
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
