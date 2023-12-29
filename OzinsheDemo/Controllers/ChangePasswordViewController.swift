//
//  ChangePasswordViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 21.12.2023.
//

import UIKit
import Localize_Swift

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPassLabel: UILabel!
    @IBOutlet weak var savePassChangesButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    

    var iconClick = true
    @IBOutlet weak var passTextfield: UITextField! {
        didSet {
            passTextfield.placeholder = "YOUR_PASSWORD".localized()
            passTextfield.tintColor = UIColor.lightGray
            passTextfield.setIcon(UIImage(imageLiteralResourceName: "Password"))
        }
    }
    
    @IBOutlet weak var confirmPassTF: UITextField! {
        didSet {
            confirmPassTF.placeholder = "YOUR_PASSWORD".localized()
            confirmPassTF.tintColor = UIColor.lightGray
            confirmPassTF.setIcon(UIImage(imageLiteralResourceName: "Password"))
        }
    }
    
    @IBAction func iconShow(_ sender: Any) {
        if iconClick {
            passTextfield.isSecureTextEntry = false
        } else {
            passTextfield.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    @IBAction func confirmIconShow(_ sender: Any) {
        if iconClick {
            confirmPassTF.isSecureTextEntry = false
        } else {
            confirmPassTF.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    
    @IBAction func savePassAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      configureViews()
    }
    
    func configureViews() {
        navigationBar.title = "CHANGE_PASSWORD".localized()
        passwordLabel.text = "PASSWORD".localized()
        repeatPassLabel.text = "REPEAT_PASSWORD".localized()
        savePassChangesButton.setTitle("SAVE_CHANGES".localized(), for: .normal)
        savePassChangesButton.layer.cornerRadius = 12
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


