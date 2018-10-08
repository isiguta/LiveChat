//
//  RegisterViewController.swift
//  LiveChat
//
//  Created by Ihor Sihuta on 9/24/18.
//  Copyright © 2018 hustlehard. All rights reserved.
//

import UIKit
import  FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func register(_ sender: Any) {
        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) {
            (result, error) in
            if let err = error {
                print("Something went wrong!!:\n\(err)")
            } else {
                print(result)
            }
        }
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
