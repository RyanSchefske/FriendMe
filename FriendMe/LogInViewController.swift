//
//  ViewController.swift
//  FriendHub
//
//  Created by Ryan Schefske on 2/17/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    // Declare variables
    var usernames = [String?]()
    var names = [String?]()
    
    // Create alerts
    func displayAlert(title:String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            
        // Do not segue when "OK" is clicked
        self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    // Set up outlets
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    
    @IBAction func logInButton(_ sender: Any) {
        
        // Check to see if all fields are filled in when button is clicked
        if username.text == "" || password.text == "" {
            
            displayAlert(title: "Error in log in", message: "Please fill all text fields.")
            
        } else {
            
            // Pause screen and show loading sign until profile is found
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            
            PFUser.logInWithUsername(inBackground: username.text!, password: password.text!, block: { (user, error) in
                
                // Stop the loading sign when profile is found
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                
                if (user != nil) {
                    
                    // Find all other app users and add them to an array to set up home screen during segue
                    let query = PFQuery(className: "Profile")
                    query.whereKey("username", notEqualTo: PFUser.current()?.username)
                    query.findObjectsInBackground(block: { (users, error) in
                        
                        if error != nil {
                            self.displayAlert(title: "Error", message: "Data could not be received")
                        } else if let users = users {
                            
                            for user in users {
                                
                                if let name = user["name"] as? String {
                                    self.names.append(name)
                                }
                                if let username = user["username"] as? String {
                                    self.usernames.append(username)
                                }
                                
                            }
                            
                            // Bring user to home screen after logged in
                            self.performSegue(withIdentifier: "showHomeScreen", sender: self)
                        }
                        
                    })
                    
                } else {
                    
                    var errorText = "Unknown error: please try again"
                    
                    if let error = error {
                        
                        errorText = error.localizedDescription
                        
                    }
                    
                    self.displayAlert(title: "Could not sign in", message: errorText)
                    
                }
            })
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If user is already logged in
        if PFUser.current() != nil {
            
            // Pause screen for loading
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            self.view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            // Find all other app users and add them to an array to set up home screen during segue
            let query = PFQuery(className: "Profile")
            query.whereKey("username", notEqualTo: PFUser.current()?.username)
            query.findObjectsInBackground(block: { (users, error) in
                
                if error != nil {
                    self.displayAlert(title: "Error", message: "Data could not be received")
                } else if let users = users {
                    
                    for user in users {
                        
                        if let name = user["name"] as? String {
                            self.names.append(name)
                        }
                        if let username = user["username"] as? String {
                            self.usernames.append(username)
                        }
                        
                    }
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.performSegue(withIdentifier: "showHomeScreen", sender: self)
                }
                
            })
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Display users on the home screen when segue occurs
        if segue.identifier == "showHomeScreen"{
            let DestViewController = segue.destination as! UINavigationController
            let targetController = DestViewController.topViewController as! HomeTableViewController
            if let name = names as? [String] {
                targetController.names = name
            }
            if let username = usernames as? [String] {
                targetController.usernames = username
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

