//
//  ChangePasswordViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 21.12.2023.
//

import UIKit
import Localize_Swift
import SwiftyJSON
import SVProgressHUD
import Alamofire

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPassLabel: UILabel!
    @IBOutlet weak var savePassChangesButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var passTextfield: TextFieldWithPadding!
    @IBOutlet weak var confirmPassTF: TextFieldWithPadding!
    
    @IBAction func iconShow(_ sender: Any) {
        passTextfield.isSecureTextEntry = !passTextfield.isSecureTextEntry
    }
    
    @IBAction func confirmIconShow(_ sender: Any) {
        confirmPassTF.isSecureTextEntry = !confirmPassTF.isSecureTextEntry
    }
    
    
    @IBAction func savePassAction(_ sender: Any) {
        let password = passTextfield.text!
        let repeatedPass = confirmPassTF.text!
        
        if password.isEmpty || repeatedPass.isEmpty {
            return
        }
        
        if password == repeatedPass {
            
            SVProgressHUD.show()
            let parameters = ["password": password]
            let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
            
            AF.request(URLs.CHANGE_PASS_URL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
                
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
                        SVProgressHUD.showSuccess(withStatus: "PASS_CHANGED".localized())
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()

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
        
        passTextfield.layer.cornerRadius = 12
        passTextfield.layer.borderWidth = 1
        passTextfield.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        passTextfield.placeholder = "YOUR_PASSWORD".localized()
        
        confirmPassTF.layer.cornerRadius = 12
        confirmPassTF.layer.borderWidth = 1
        confirmPassTF.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
        confirmPassTF.placeholder = "YOUR_PASSWORD".localized()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func textfiledEditDidBegin(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 151/255, green: 83/255, blue: 240/255, alpha: 1.0).cgColor
    }
    
    @IBAction func textfieldEditDidEnd(_ sender: TextFieldWithPadding) {
        sender.layer.borderColor = UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor
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


