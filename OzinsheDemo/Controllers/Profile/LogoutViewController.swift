//
//  LogoutViewController.swift
//  OzinsheDemo
//
//  Created by Aset Bakirov on 21.12.2023.
//

import UIKit
import Localize_Swift

class LogoutViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var exitLabel: UILabel!
    @IBOutlet weak var subExitLabel: UILabel!
    @IBOutlet weak var confirmExitButton: UIButton!
    @IBOutlet weak var confirmNoExitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        tap.delegate = self
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      configureViews()
    }
    
    @objc func dismissView() {
      self.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
      if (touch.view?.isDescendant(of: backgroundView))! {
        return false
      }
      return true
    }
    
    func configureViews() {
        backgroundView.layer.cornerRadius = 32.0
        backgroundView.clipsToBounds = true
        backgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        exitLabel.text = "EXIT".localized()
        subExitLabel.text = "CONFIRM_EXIT_FROM_ACCOUNT".localized()
        confirmExitButton.setTitle("YES_EXIT".localized(), for: .normal)
        confirmNoExitButton.setTitle("NO".localized(), for: .normal)
        confirmExitButton.layer.cornerRadius = 12
        confirmNoExitButton.layer.cornerRadius = 12
    }

    @IBAction func logoutActionButton(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "birthDate")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        
        
        let rootViewController = self.storyboard?.instantiateViewController(identifier: "SigninNavigationViewController") as! UINavigationController
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootViewController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func cancelLogout(_ sender: Any) {
        dismissView()
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
