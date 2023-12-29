//
//  LoginViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 22.12.2023.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    var iconClick = true
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.layer.cornerRadius = 12
            emailTextField.layer.borderWidth = 1
            emailTextField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
            emailTextField.setIcon(UIImage(imageLiteralResourceName: "Message"))
        }
    }
    
    @IBOutlet weak var passTextField: UITextField! {
        didSet {
            passTextField.layer.cornerRadius = 12
            passTextField.layer.borderWidth = 1
            passTextField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
            passTextField.tintColor = UIColor.lightGray
            //passTextField.tintColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0)
            passTextField.setIcon(UIImage(imageLiteralResourceName: "Password"))
        }
    }
    
    @IBOutlet weak var enterButton: UIButton! {
        didSet {
            enterButton.layer.cornerRadius = 12
        }
    }
    
    @IBOutlet weak var appleEnterButton: UIButton! {
        didSet {
            appleEnterButton.layer.cornerRadius = 12
            appleEnterButton.layer.borderWidth = 1.5
            appleEnterButton.layer.borderColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1.0).cgColor
        }
    }
    
    @IBOutlet weak var googleEnterButton: UIButton! {
        didSet {
            googleEnterButton.layer.cornerRadius = 12
            googleEnterButton.layer.borderWidth = 1.5
            googleEnterButton.layer.borderColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1.0).cgColor
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        textFieldDidBeginEditing(emailTextField)
        textFieldDidEndEditing(emailTextField)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func showPassTF(_ sender: Any) {
        if iconClick {
            passTextField.isSecureTextEntry = false
        } else {
            passTextField.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            //textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
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
