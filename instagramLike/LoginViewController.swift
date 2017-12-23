//
//  LoginViewController.swift
//  instagramLike
//
//  Created by 笹倉 一也 on 2017/12/23.
//  Copyright © 2017年 笹倉 一也. All rights reserved.
//

import UIKit
import Firebase



class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var pwField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        
        guard emailField.text != "", pwField.text != "" else { return }
        
        Auth.auth().signIn(withEmail: emailField.text!, password: pwField.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let user = user {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "usersVC")
                
                self.present(vc, animated: true, completion: nil)
                
            }
        }
        
    }
    
    
}
