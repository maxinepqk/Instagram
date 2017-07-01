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
    var wrongPasswordAlertController = UIAlertController(title: "Incorrect password", message: "The password you entered is incorrect. Please try again.", preferredStyle: .alert)
    var noUsernameAlertController = UIAlertController(title: "No username", message: "Please enter a username and try again.", preferredStyle: .alert)
    var invalidUsernameAlertController = UIAlertController(title: "Username is already taken", message: "The username you entered is already taken. Please enter a new one and try again.", preferredStyle: .alert)

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //Create alert controllers
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .cancel) { (action) in
        }
        wrongPasswordAlertController.addAction(tryAgainAction)
        noUsernameAlertController.addAction(tryAgainAction)
        invalidUsernameAlertController.addAction(tryAgainAction)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
                    self.present(self.wrongPasswordAlertController, animated: true)
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
                let code = (error as NSError).code
                if code == 200 {
                    self.present(self.noUsernameAlertController, animated: true)
                } else if code == 202 {
                    self.present(self.invalidUsernameAlertController, animated: true)
                }

            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("User registered successfully")
            }
        }
    }
    
    
}
