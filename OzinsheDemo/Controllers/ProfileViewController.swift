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
    
    @IBOutlet weak var personalDataButton: UIButton!
    @IBOutlet weak var personalDataEditLabel: UILabel!
    
    @IBOutlet weak var changePassButton: UIButton!
    
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var announcementButton: UIButton!
    @IBOutlet weak var darkModeButton: UIButton!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    
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
        personalDataButton.setTitle("PERSONAL_DATA".localized(), for: .normal)
        personalDataEditLabel.text = "EDIT".localized()
        changePassButton.setTitle("CHANGE_PASSWORD".localized(), for: .normal)
        announcementButton.setTitle("ANNOUNCEMENT".localized(), for: .normal)
        darkModeButton.setTitle("DARK_MODE".localized(), for: .normal)
        termsButton.setTitle("TERMS_AND_CONDITIONS".localized(), for: .normal)
        navigationBar.title = "PROFILE".localized()
        
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
    
    
    @IBAction func personalDataShow(_ sender: Any) {
        let personalDataVC = storyboard?.instantiateViewController(withIdentifier: "ProfileEditViewController") as! ProfileEditViewController
        navigationController?.show(personalDataVC, sender: self)
        
    }
    
    @IBAction func changePassShow(_ sender: Any) {
        let changePassVC = storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        navigationController?.show(changePassVC, sender: self)
    }
    
    @IBAction func exitButton(_ sender: Any) {
        let exitVC = storyboard?.instantiateViewController(withIdentifier: "LogoutViewController") as! LogoutViewController
        exitVC.modalPresentationStyle = .overFullScreen
        present(exitVC, animated: true, completion: nil)
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
