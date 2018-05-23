//
//  YourProfileViewController.swift
//  FriendHub
//
//  Created by Ryan Schefske on 2/19/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class YourProfileViewController: UIViewController {
    
    // Logs out current user if log out button is selected
    @IBAction func LogOutButton(_ sender: Any) {
        PFUser.logOut()
    }
    
    // Outlets for social media accounts
    @IBOutlet var twitterOutlet: UIButton!
    @IBOutlet var instagramOutlet: UIButton!
    @IBOutlet var snapchatOutlet: UIButton!
    @IBOutlet var facebookOutlet: UIButton!
    
    // Variables
    var instagram:String?
    var twitter:String?
    var snapchat:String?
    var facebook:String?
    var activeName:String?
    var profilePicture:PFFile?
    var bio1:String?
    var userUsername:String?
    var names = [String?]()
    var usernames = [String?]()
    
    // Alert with no segue
    func displayAlertYourProfile(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    // Sets up home screen again when home button is selected
    @IBAction func homeButton(_ sender: Any) {
        
        // Loading symbol
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Reloads other users to display on home screen
        let query = PFQuery(className: "Profile")
        query.whereKey("username", notEqualTo: PFUser.current()?.username)
        query.findObjectsInBackground(block: { (users, error) in
            
            if error != nil {
                self.displayAlertYourProfile(title: "Error", message: "Data could not be received")
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
                self.performSegue(withIdentifier: "fromYourProfile", sender: self)
            }
        })
        
    }
    
    // Segues to your instagram page if you have an instagram set up
    @IBAction func instagram(_ sender: Any) {
        if let instagramName = instagram {
            
            if instagramName == "" {
                displayAlertYourProfile(title: "Instagram Not Found", message: "You have not set up an instagram account")
            } else {
                
                // Uses instagram url to display your instagram
                if let urlInstagram = URL(string: "https://instagram.com/" + instagramName + "/") {
                    
                    UIApplication.shared.open(urlInstagram)
                }
            }
        }
        
        // Double checks to make sure there is an instagram set up
        if instagram == nil {
            displayAlertYourProfile(title: "Instagram Not Found", message: "You have not set up an instagram account")
        }
    }
    
    // Segues to your twitter page if you have a twitter set up
    @IBAction func twitter(_ sender: Any) {
        
        if let twitterHandle = twitter {
            
            if twitterHandle == "" {
                
                displayAlertYourProfile(title: "Twitter Not Found", message: "You have not set up a twitter account")
                
            } else {
                if let urlTwitter = URL(string: "https://www.twitter.com/" + twitterHandle) {
                UIApplication.shared.open(urlTwitter)
                }
            }
        }
        if twitter == nil {
            displayAlertYourProfile(title: "Twitter Not Found", message: "You have not set up a twitter account")
        }
    }
    
    // Segues to your snapchat if you have a snapchat set up
    @IBAction func snapchatButton(_ sender: Any) {
        
        if let snap = snapchat {
            
            if snap == "" {
                displayAlertYourProfile(title: "Snapchat Not Found", message: "You have not set up a snapchat")
            } else {
                if let urlSnapchat = URL(string: "https://www.snapchat.com/add/" + snap) {
                    UIApplication.shared.open(urlSnapchat)
                }
            }
        }
        if snapchat == nil {
            displayAlertYourProfile(title: "Snapchat Not Found", message: "You have not set up a snapchat")
        }
        
    }
    
    // Segues to your facebook if you have a facebook set up
    @IBAction func facebookButton(_ sender: Any) {
        
        if let fb = facebook {
            if fb == "" {
                displayAlertYourProfile(title: "Facebook Not Found", message: "You have not set up a Facebook account")
            } else {
                if let urlFacebook = URL(string: fb) {
                    UIApplication.shared.open(urlFacebook)
                }
            }
        }
        if facebook == nil {
            displayAlertYourProfile(title: "Facebook Not Found", message: "You have not set up a Facebook account")
        }
    }
    
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var picture: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var bio: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // Google Ads
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        */
        
        // Button's appear slightly rounded instead of boxes
        self.twitterOutlet.layer.cornerRadius = self.twitterOutlet.frame.height / 2
        self.instagramOutlet.layer.cornerRadius = self.instagramOutlet.frame.height / 2
        self.snapchatOutlet.layer.cornerRadius = self.snapchatOutlet.frame.height / 2
        self.facebookOutlet.layer.cornerRadius = self.facebookOutlet.frame.height / 2
        
        // Sets your name to display
        if let name = activeName {
            self.nameLabel.text = name
        }
        
        // Displays your username on your profile
        if let username1 = userUsername {
            self.username.text = username1
        }
        
        // Dispays your bio
        if let userBio = bio1 {
            self.bio.text = userBio
        }
        
        // Makes profile picture appear in a circle rather than square
        self.picture.layer.borderWidth = 1
        self.picture.layer.masksToBounds = false
        self.picture.layer.borderColor = UIColor.black.cgColor
        self.picture.layer.cornerRadius = self.picture.frame.height/2
        self.picture.clipsToBounds = true
        
        // Changes your profile picture from a file to a png
        if let imageFile = self.profilePicture {
            imageFile.getDataInBackground(block: { (data, error) in
                if let imageData = data {
                    if let imageToDisplay = UIImage(data: imageData) {
                        self.picture.image = imageToDisplay
                    }
                }
            })
        }
        
        // Displays default profile picture if no profile picture is available
        if self.picture.image == nil {
            self.picture.image = #imageLiteral(resourceName: "defaultUser.png")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Sets up home screen
        if segue.identifier == "fromYourProfile"{
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

}
