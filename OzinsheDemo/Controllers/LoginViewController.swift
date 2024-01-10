//
//  LoginViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 22.12.2023.
//

import UIKit
import SwiftyJSON
import SVProgressHUD
import Alamofire
import Localize_Swift

class LoginViewController: UIViewController/*, UITextFieldDelegate*/ {
    var iconClick = true
    
    @IBOutlet weak var emailTextField: TextFieldWithPadding!
    @IBOutlet weak var passTextField: TextFieldWithPadding!
    @IBOutlet weak var enterButton: UIButton!
    @IBOutlet weak var appleEnterButton: UIButton!
    @IBOutlet weak var googleEnterButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var subWelcomeLabel: UILabel!
    @IBOutlet weak var signupLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        hideKeyboardWhenTappedAround()
//        emailTextField.delegate = self
//        textFieldDidBeginEditing(emailTextField)
//        textFieldDidEndEditing(emailTextField)
    }
    
    func configureViews() {
        emailTextField.layer.cornerRadius = 12
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        emailTextField.placeholder = "YOUR_EMAIL".localized()
        //emailTextField.setIcon(UIImage(imageLiteralResourceName: "Message"))
        
        passTextField.layer.cornerRadius = 12
        passTextField.layer.borderWidth = 1
        passTextField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        passTextField.placeholder = "YOUR_PASSWORD".localized()
        //passTextField.tintColor = UIColor.lightGray
        //passTextField.tintColor = UIColor(red: 156/255, green: 163/255, blue: 175/255, alpha: 1.0)
        //passTextField.setIcon(UIImage(imageLiteralResourceName: "Password"))
        
        enterButton.layer.cornerRadius = 12
        
        appleEnterButton.layer.cornerRadius = 12
        appleEnterButton.layer.borderWidth = 1.5
        appleEnterButton.layer.borderColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1.0).cgColor
        
        googleEnterButton.layer.cornerRadius = 12
        googleEnterButton.layer.borderWidth = 1.5
        googleEnterButton.layer.borderColor = UIColor(red: 229/255, green: 231/255, blue: 235/255, alpha: 1.0).cgColor
        
        welcomeLabel.text = "HELLO".localized()
        subWelcomeLabel.text = "LOGIN_INTO_ACCOUNT".localized()
        enterButton.setTitle("LOGIN".localized(), for: .normal)
        signupLabel.text = "NO_ACCOUNT".localized()
        signupButton.setTitle("SIGN_UP".localized(), for: .normal)
        passwordLabel.text = "PASSWORD".localized()
    
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func enterButtonAction(_ sender: Any) {
        let email = emailTextField.text!
        let password = passTextField.text!
        
        if email.isEmpty || password.isEmpty {
            return
        }
        
        SVProgressHUD.show()
        
        let parameters = ["email": email, "password": password]
        
        AF.request(URLs.SIGN_IN_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let token = json["accessToken"].string {
                    Storage.sharedInstance.accessToken = token
                    UserDefaults.standard.set(token, forKey: "accessToken")
                    self.startApp()
                } else {
                    SVProgressHUD.showError(withStatus: "CONNECTION_ERROR")
                }
            } else {
                var ErrorString = "CONNECTION_ERROR"
                if let sCode = response.response?.statusCode {
                    ErrorString = ErrorString + " \(sCode)"
                }
                ErrorString = ErrorString + " \(resultString)"
                SVProgressHUD.showError(withStatus: "\(ErrorString)")
            }
        }
    }
    
    @IBAction func goToSignupButton(_ sender: Any) {
        let signupVC = storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        navigationController?.show(signupVC, sender: self)
    }
    
    func startApp() {
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        tabViewController?.modalPresentationStyle = .fullScreen
        self.present(tabViewController!, animated: true, completion: nil)
    }
    
    @IBAction func showPassTF(_ sender: Any) {
        passTextField.isSecureTextEntry = !passTextField.isSecureTextEntry
        
//        if iconClick {
//            passTextField.isSecureTextEntry = false
//        } else {
//            passTextField.isSecureTextEntry = true
//        }
//        iconClick = !iconClick
    }
    
    
    @IBAction func textFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    
    @IBAction func textFieldEditingDidEdn(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
    }
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField == emailTextField {
//            //textField.layer.borderWidth = 1
//            textField.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
//        }
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        textField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
