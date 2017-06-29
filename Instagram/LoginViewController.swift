//
//  LoginViewController.swift
//  Instagram
//
//  Created by Maxine Kwan on 6/27/17.
//  Copyright © 2017 Maxine Kwan. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var alertController = UIAlertController(title: "Incorrect password", message: "The password you entered is incorrect. Please try again.", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create alert controller
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .cancel) { (action) in
        }
        alertController.addAction(tryAgainAction)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(_ sender: Any) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                let code = (error as NSError).code
                if code == 101 {
                    self.present(self.alertController, animated: true)
                }
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("Log in successful")
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("User registered successfully")
            }
        }
    }
    
    
}
