//
//  Register_or_login.swift
//  RateMyMusic
//
//  Created by Vivaan Baid on 20/06/21.
//

import Foundation
import UIKit
import Firebase

class Register_or_login: UIViewController{
    
    let defaults = UserDefaults.standard
    
   
    
    
    @IBOutlet weak var sign_up_outlet: UIButton!
    
    @IBAction func sign_up_pressed(_ sender: Any) {
        
    }
    
    func checkloginstate(){
        DispatchQueue.main.async {
            if self.defaults.bool(forKey: "Loggedinstate") == true {
                self.performSegue(withIdentifier: K.signedinsegue, sender: self)
            }else {
                print("do whatever")
                return
            }
        }
      
    }
    
    

    @IBOutlet weak var login_outlet: UIButton!
    
    @IBAction func login_pressed(_ sender: Any) {
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkloginstate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addgradientlayer()
        makebuttonscooler(textfield: sign_up_outlet)
        makebuttonscooler(textfield: login_outlet)
        
    }
    func addgradientlayer(){
        let gradientlayer = CAGradientLayer()
        gradientlayer.colors = [UIColor(named: "myorange")!.cgColor, UIColor(named: "mypink")!.cgColor]
        gradientlayer.frame = self.view.bounds
        view.layer.insertSublayer(gradientlayer, at: 0)
    }
    func makebuttonscooler(textfield: UIButton){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: textfield.frame.height - 1, width: textfield.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.white.cgColor
        textfield.layer.addSublayer(bottomLine)
    }
    
}
