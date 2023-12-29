//
//  ProfileEditViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 19.12.2023.
//

import UIKit
import Localize_Swift

class ProfileEditViewController: UIViewController {
    
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      configureViews()
    }
    
    func configureViews() {
        yourNameLabel.text = "YOUR_NAME".localized()
        telephoneLabel.text = "TELEPHONE".localized()
        birthDateLabel.text = "DATE_OF_BIRTH".localized()
        navigationBar.title = "PERSONAL_DATA".localized()
        saveChangesButton.setTitle("SAVE_CHANGES".localized(), for: .normal)
        saveChangesButton.layer.cornerRadius = 12
    }

    @IBAction func saveChangesAction(_ sender: Any) {
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
