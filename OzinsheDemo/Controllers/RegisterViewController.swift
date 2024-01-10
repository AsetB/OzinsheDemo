//
//  RegisterViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 07.01.2024.
//

import UIKit
import Localize_Swift
import SwiftyJSON
import SVProgressHUD
import Alamofire

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registrationLabel: UILabel!
    @IBOutlet weak var subRegisterLabel: UILabel!
    @IBOutlet weak var emailTextfield: TextFieldWithPadding!
    @IBOutlet weak var passTextfield: TextFieldWithPadding!
    @IBOutlet weak var repeatPassTextfield: TextFieldWithPadding!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passLabel: UILabel!
    @IBOutlet weak var repeatPassLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var gotoLoginLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerActionButton(_ sender: Any) {
        let email = emailTextfield.text!
        let password = passTextfield.text!
        let repeatedPass = repeatPassTextfield.text!
        
        if email.isEmpty || password.isEmpty {
            return
        }
        
        if password == repeatedPass {
            
            SVProgressHUD.show()
            
            let parameters = ["email": email, "password": password]
            
            AF.request(URLs.SIGN_UP_URL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
                
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
        } else {
            SVProgressHUD.showError(withStatus: "PASS_NOT_MATCH".localized())
        }
    }
    
    @IBAction func gotoLoginActionButton(_ sender: Any) {
        let signinVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        navigationController?.show(signinVC, sender: self)
    }
    
    
    @IBAction func showPassTF(_ sender: Any) {
        passTextfield.isSecureTextEntry = !passTextfield.isSecureTextEntry
    }
    
    @IBAction func showRepeatPassTF(_ sender: Any) {
        repeatPassTextfield.isSecureTextEntry = !repeatPassTextfield.isSecureTextEntry
    }
    
    @IBAction func textFieldEditDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    
    @IBAction func textFieldEditDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
    }
    
    func startApp() {
        let tabViewController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        tabViewController?.modalPresentationStyle = .fullScreen
        self.present(tabViewController!, animated: true, completion: nil)
    }
    
    func configureViews() {
        emailTextfield.layer.cornerRadius = 12
        emailTextfield.layer.borderWidth = 1
        emailTextfield.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        emailTextfield.placeholder = "YOUR_EMAIL".localized()
        
        passTextfield.layer.cornerRadius = 12
        passTextfield.layer.borderWidth = 1
        passTextfield.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        passTextfield.placeholder = "YOUR_PASSWORD".localized()
        
        repeatPassTextfield.layer.cornerRadius = 12
        repeatPassTextfield.layer.borderWidth = 1
        repeatPassTextfield.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        repeatPassTextfield.placeholder = "YOUR_PASSWORD".localized()
        
        registerButton.layer.cornerRadius = 12
        registerButton.setTitle("SIGN_UP".localized(), for: .normal)
        
        registrationLabel.text = "SIGN_UP".localized()
        subRegisterLabel.text = "FILL_IN_DATA".localized()
        passLabel.text = "PASSWORD".localized()
        repeatPassLabel.text = "REPEAT_PASSWORD".localized()
        gotoLoginLabel.text = "GOT_ACCOUNT".localized()
        loginButton.setTitle("LOGIN".localized(), for: .normal)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
