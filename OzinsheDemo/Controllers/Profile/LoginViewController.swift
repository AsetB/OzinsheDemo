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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var errorLabelTopToEmailTFBottom: NSLayoutConstraint!
    @IBOutlet weak var passLabelTopToEmailTFBottom: NSLayoutConstraint!
    @IBOutlet weak var errorLabelBottomToPassLabelTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        hideKeyboardWhenTappedAround()
    }
    
    func configureViews() {
        emailTextField.layer.cornerRadius = 12
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        emailTextField.placeholder = "YOUR_EMAIL".localized()
        
        passTextField.layer.cornerRadius = 12
        passTextField.layer.borderWidth = 1
        passTextField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        passTextField.placeholder = "YOUR_PASSWORD".localized()
        
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
        
        errorLabel.text = "WRONG_FORMAT".localized()
        errorLabel.isHidden = true
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func emailTextfieldEditingChange(_ sender: Any) {
        if !emailTextField.text!.isEmail() {
            errorLabel.isHidden = false
            errorLabelTopToEmailTFBottom.priority = .defaultHigh
            passLabelTopToEmailTFBottom.priority = .defaultLow
            errorLabelBottomToPassLabelTop.priority = .defaultHigh
            emailTextField.layer.borderColor = UIColor(red: 255/255, green: 64/255, blue: 43/255, alpha: 1.0).cgColor
        } else {
            errorLabel.isHidden = true
            errorLabelTopToEmailTFBottom.priority = .defaultLow
            passLabelTopToEmailTFBottom.priority = .defaultHigh
            errorLabelBottomToPassLabelTop.priority = .defaultLow
            emailTextField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        }
        
        if emailTextField.text!.isEmpty {
            errorLabel.isHidden = true
            errorLabelTopToEmailTFBottom.priority = .defaultLow
            passLabelTopToEmailTFBottom.priority = .defaultHigh
            errorLabelBottomToPassLabelTop.priority = .defaultLow
            emailTextField.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        }
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
    }
    
    
    @IBAction func textFieldEditingDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    
    @IBAction func textFieldEditingDidEdn(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        errorLabel.isHidden = true
        errorLabelTopToEmailTFBottom.priority = .defaultLow
        passLabelTopToEmailTFBottom.priority = .defaultHigh
        errorLabelBottomToPassLabelTop.priority = .defaultLow
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
