//
//  CreateAccountViewController.swift
//  FriendMe
//
//  Created by Ryan Schefske on 2/17/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

import UIKit
import Parse

class CreateAccountViewController: UIViewController {
    
    // Alert with no segue
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
        }
    
    // Alert with segue to EditProfileViewController to make it easier for the user to finish setting up their account
    func createdAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "finishSettingUp", sender: self)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBOutlet var email: UITextField!
    @IBAction func createAccount(_ sender: Any) {
        
        // Make sure all fields are filled in
        if username.text == "" || password.text == "" || email.text == "" {
            displayAlert(title: "Error in sign up", message: "Please fill out all fields")
        } else {
            
            // Loading Indicator
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // Sets user to current user
            let user = PFUser()
            
            // Saves user information to server
            user.username = username.text
            user.password = password.text
            user.email = email.text
            user["twitter"] = ""
            user["instagram"] = ""
            user["snapchat"] = ""
            user["facebook"] = ""
            user["name"] = ""
            user["profilePicture"] = ""
            user["bio"] = ""
            
            
            user.signUpInBackground(block: { (success, error) in
                
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if let error = error {
                    
                    self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
                    
                    
                } else {
                    
                    self.createdAlert(title: "Account Created", message: "Now let's finish setting up your profile")
                    
                }
                
            })
            
        }
        
    }
    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
