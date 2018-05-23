//
//  ProfileViewController.swift
//  FriendHub
//
//  Created by Ryan Schefske on 2/18/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class ProfileViewController: UIViewController {
    
    // Variables
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var twitterOutlet: UIButton!
    @IBOutlet var instagramOutlet: UIButton!
    @IBOutlet var snapchatOutlet: UIButton!
    @IBOutlet var facebookOutlet: UIButton!
    @IBOutlet var picture: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var bioLabel: UILabel!
    //var interstitial: GADInterstitial!
    var adUsed: Bool?
    var names = [String?]()
    var usernames = [String?]()
    
    @IBAction func homeButton(_ sender: Any) {
        
        // When home button is selected, removes information from previously selected user
        twitterHandle = ""
        instagramName = ""
        snapName = ""
        facebookName = ""
        bio = ""
        activeUser = ""
        
        // Loading symbol
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Sets up home screen again
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
                self.performSegue(withIdentifier: "toHomeScreen", sender: self)
            }
        })
    }
    
    // Alert with no segue
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBOutlet var nameLabel: UILabel!
    
    var twitterHandle:String?
    var instagramName:String?
    var snapName:String?
    var facebookName:String?
    var activeUser:String?
    var profilePicture:PFFile?
    var bio:String?
    var activeUsername:String?
    
    // Segues to selected user's instagram if they have one set up
    @IBAction func instagramButton(_ sender: Any) {
        
        if  let instagram = instagramName {
            
            // Checks to see if user has instagram set up
            if instagram == "" {
                displayAlert(title: "Instagram Not Found", message: "User does not have an instagram set up")
                
            } else {
                
                // Uses instagram url to segue to user's instagram
                if let urlInstagram = URL(string: "https://www.instagram.com/" + instagram + "/") {
                    
                    UIApplication.shared.open(urlInstagram)
                
                }
            }
        }
        
        // Double checks to see if user has instagram set up
        if instagramName == nil {
                    
            displayAlert(title: "Instagram Not Found", message: "User does not have an instagram set up")
                    
        }
        
    }
    
    // Segues to selected user's twitter if they have one set up
    @IBAction func twitterButton(_ sender: Any) {
        
        if let twitter = twitterHandle {
            
            if twitter == "" {
                
                displayAlert(title: "Twitter Not Found", message: "User does not have a twitter set up")
                
            } else {
            
                if let urlTwitter = URL(string: "https://www.twitter.com/" + twitter) {
                    UIApplication.shared.open(urlTwitter)
                
                }
            }
        }
        
        if twitterHandle == nil {
            displayAlert(title: "Twitter Not Found", message: "User does not have a twitter set up")
        }
        
    }
    
    // Segues to selected user's snapchat if they have one set up
    @IBAction func snapchatButton(_ sender: Any) {
        
        if let snap = snapName {
            if snap == "" {
                displayAlert(title: "Snapchat Not Found", message: "User does not have a snapchat")
            } else {
                
                if let urlSnap = URL(string: "https://www.snapchat.com/add/" + snap) {
                    UIApplication.shared.open(urlSnap)
                }
                
            }
        }
        if snapName == nil {
            displayAlert(title: "Snapchat Not Found", message: "User does not have a snapchat")
        }
    }
    
    // Segues to selected user's facebook if they have one set up
    @IBAction func facebookButton(_ sender: Any) {
        
        if let fb = facebookName {
            if fb == "" {
                displayAlert(title: "Facebook Not Found", message: "User does not have a Facebook")
            } else {
                
                if let urlFacebook = URL(string: fb) {
                    UIApplication.shared.open(urlFacebook)
                }
                
            }
        }
        if facebookName == nil {
            displayAlert(title: "Facebook Not Found", message: "User does not have a Facebook")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // Google Ads
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        */
        
        // Button's appear rounded instead of boxed
        self.twitterOutlet.layer.cornerRadius = self.twitterOutlet.frame.height / 2
        self.instagramOutlet.layer.cornerRadius = self.instagramOutlet.frame.height / 2
        self.snapchatOutlet.layer.cornerRadius = self.snapchatOutlet.frame.height / 2
        self.facebookOutlet.layer.cornerRadius = self.facebookOutlet.frame.height / 2
        
        // Displays user's information in their profile
        if let active = activeUser {
            self.nameLabel.text = active
        }
        if let bio2 = bio {
            self.bioLabel.text = bio2
        }
        if let username1 = activeUsername {
            self.usernameLabel.text = username1
        }
        
        // Makes profile picture appear in a circle rather than square
        picture.layer.borderWidth = 1
        picture.layer.masksToBounds = false
        picture.layer.borderColor = UIColor.black.cgColor
        picture.layer.cornerRadius = picture.frame.height/2
        picture.clipsToBounds = true
        
        // Converts image from a file to a png
        if let imageFile = profilePicture {
            imageFile.getDataInBackground(block: { (data, error) in
                if let imageData = data {
                    if let imageToDisplay = UIImage(data: imageData) {
                        self.picture.image = imageToDisplay
                    }
                }
            })
        }
        // If user does not have a profile picture, the default picture will be used
        if self.picture.image == nil {
            self.picture.image = #imageLiteral(resourceName: "defaultUser.png")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Sets up home screen
        if segue.identifier == "toHomeScreen"{
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
