//
//  log_in_vc.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 21/06/21.
//

import Foundation
import UIKit
import Firebase

class log_in_vc: UIViewController{
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var emailtxtfield: UITextField!
    
    @IBOutlet weak var passwordtxtfield: UITextField!
    
    @IBAction func log_in_pressed(_ sender: Any) {
        if let email = emailtxtfield.text, let password = passwordtxtfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { results, error in
                if let e = error {
                    print(e.localizedDescription)
                }else {
                    print("successfully logged in")
                    self.defaults.set(true, forKey: "Loggedinstate")
                    self.performSegue(withIdentifier: K.logintohomesegue, sender: self)
                }
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addgradientlayer()
        makebuttonscooler(textfield: emailtxtfield)
        makebuttonscooler(textfield: passwordtxtfield)
        
        emailtxtfield.delegate = self
        passwordtxtfield.delegate = self
    }
    
    func addgradientlayer(){
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [UIColor(named: "myorange")!.cgColor, UIColor(named: "mypink")!.cgColor]
        gradientlayer.frame = self.view.bounds
        view.layer.insertSublayer(gradientlayer, at: 0)
    }
    
    func makebuttonscooler(textfield: UITextField){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textfield.borderStyle = UITextField.BorderStyle.none
        textfield.layer.addSublayer(bottomLine)
    }
}

extension log_in_vc: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
