//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Hunter Boleman on 3/21/19.
//  Copyright © 2019 Hunter Boleman. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    //-------------------- Class Setup --------------------//
    
    // Outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //-------------------- Button Actions --------------------//
    
    @IBAction func onSignIn(_ sender: Any) {
        let username = usernameField.text!;
        let password = passwordField.text!;
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            if (user != nil){
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            }
            else {
                print("ERROR: signup in backround did fail: \(String(describing: error?.localizedDescription))");
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameField.text;
        user.password = passwordField.text;
        
        user.signUpInBackground { (success, error) in
            if (success){
                self.performSegue(withIdentifier: "loginSegue", sender: nil);
                print("SIGN_ON_DID_HAPPEN");
            }
            else{
                print("ERROR: signup in backround did fail: \(String(describing: error?.localizedDescription))");
            }
        }
    }
}
