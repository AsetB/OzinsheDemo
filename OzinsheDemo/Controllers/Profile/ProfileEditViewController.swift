//
//  ProfileEditViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 19.12.2023.
//

import UIKit
import Localize_Swift
import SwiftyJSON
import SVProgressHUD
import Alamofire


class ProfileEditViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate {
    
    @IBOutlet weak var yourNameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var saveChangesButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var birthDateTextfield: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        phoneTextField.delegate = self
        birthDateTextfield.delegate = self
        
        birthDateTextfield.inputView = datePicker
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(sender:)), for: .valueChanged)
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
        nameTextfield.text = UserDefaults.standard.string(forKey: "name")
        emailTextfield.text = UserDefaults.standard.string(forKey: "email")
        phoneTextField.text = UserDefaults.standard.string(forKey: "phoneNumber")
        birthDateTextfield.text = UserDefaults.standard.string(forKey: "birthDate")
    }
    

    @IBAction func saveChangesAction(_ sender: Any) {
        
        guard let birthDate = birthDateTextfield.text else { return }
        let userId = UserDefaults.standard.integer(forKey: "userId")
        let language = "English"
        guard let name = nameTextfield.text else { return }
        guard let phoneNumber = phoneTextField.text else { return }
        
        if birthDate.isEmpty || name.isEmpty || phoneNumber.isEmpty { return }
        
        SVProgressHUD.show()
        let parameters = ["birthDate": birthDate, "id": userId, "language": language, "name": name, "phoneNumber": phoneNumber] as [String : Any]
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Storage.sharedInstance.accessToken)"]
        
        AF.request(URLs.UPDATE_PROFILE_URL, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            SVProgressHUD.dismiss()
            var resultString = ""
            if let data = response.data {
                resultString = String(data: data, encoding: .utf8)!
                print(resultString)
            }
            
            if response.response?.statusCode == 200 {
                let json = JSON(response.data!)
                print("JSON: \(json)")
                
                if let name = json["name"].string {
                    UserDefaults.standard.set(name, forKey: "name")
                } else {
                    print("Error doesnt load name")
                }
                if let birthDate = json["birthDate"].string {
                    UserDefaults.standard.set(birthDate, forKey: "birthDate")
                } else {
                    print("Error doesnt load birthDate")
                }
                if let phoneNumber = json["phoneNumber"].string {
                    UserDefaults.standard.set(phoneNumber, forKey: "phoneNumber")
                } else {
                    print("Error doesnt load phoneNumber")
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
        SVProgressHUD.showSuccess(withStatus: "Profile data saved")
        configureViews()
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private lazy var datePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.sizeToFit()
        return datePicker
    }()
    
    @objc func datePickerValueChanged(sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            birthDateTextfield.text = dateFormatter.string(from: sender.date)
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
