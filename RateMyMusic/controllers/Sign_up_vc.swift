//
//  Sign_up_vc.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 20/06/21.
//

import Foundation
import UIKit
import Firebase

class Sign_up_vc: UIViewController{
    
    
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var password: UILabel!
    
    
    @IBOutlet weak var emailtxtfield: UITextField!
    
    @IBOutlet weak var passwordtxtfield: UITextField!
    
    
    @IBOutlet weak var sign_up_outlet: UIButton!
    
    
    @IBAction func sign_up_pressed(_ sender: Any) {
        if let email = emailtxtfield.text, let password = passwordtxtfield.text{
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let e = error {
                    self.showalert(errormessage: e.localizedDescription)
                }else {
                    print("user created successfully")
                    self.performSegue(withIdentifier: K.signuptonextsegue, sender: self)
                }
            }
        }
        
        
    }
    
    func configureeverything(){
        sign_up_outlet.layer.cornerRadius = 15.0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        configureeverything()
        
        
        //delegates
        emailtxtfield.delegate = self
        passwordtxtfield.delegate = self
        
        //gr!adient layer
        addgradientlayer()
        
        //make it cooler
        makebuttonscooler(textfield: emailtxtfield)
        makebuttonscooler(textfield: passwordtxtfield)
        
       
        
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
    
    func showalert(errormessage: String){
        let alert = UIAlertController(title: "oops", message: errormessage, preferredStyle:.alert)
        let action = UIAlertAction(title: "Ah Okay", style: .default) { action in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}

//text field delegate
extension Sign_up_vc: UITextFieldDelegate{

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
