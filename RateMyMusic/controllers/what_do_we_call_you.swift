//
//  what_do_we_call_you.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 20/06/21.
//

import Foundation
import UIKit

class what_Do_we_call_you: UIViewController{
    let defaults = UserDefaults.standard
    

    
    @IBOutlet weak var yourname: UITextField!
    
    
    
    @IBAction func that_is_me_pressed(_ sender: Any)
    {
        if yourname.text != nil{
            performSegue(withIdentifier: K.tohome, sender: self)
            let usernames = yourname.text
            defaults.set(usernames!, forKey: "MY_USER_NAME_1")
            print("added")
        }else {
            print("error")
        }
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addgradientlayer()
        yourname.delegate = self
    }
    
    func addgradientlayer(){
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [UIColor(named: "myorange")!.cgColor, UIColor(named: "mypink")!.cgColor]
        gradientlayer.frame = self.view.bounds
        view.layer.insertSublayer(gradientlayer, at: 0)
    }
    
    
}

extension what_Do_we_call_you: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
