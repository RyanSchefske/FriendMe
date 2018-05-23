//
//  EditProfileViewController.swift
//  FriendHub
//
//  Created by Ryan Schefske on 2/18/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var userName:String?
    var userTwitter:String?
    var userInstagram:String?
    var userSnapchat:String?
    var userFacebook:String?
    var userPic:PFFile?
    var userUsername:String?
    var userBio:String?
    var oldProfiles = [""]
    
    // TODO - Some pictures appear sideways when selected
    func rotateImage(image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy!
    }
    
    // Alert with segue to YourProfileViewController
    func savedAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "backToYourProfile", sender: self)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }


    // Returns user back to YourProfileViewController
    @IBAction func cancelButton(_ sender: Any) {
        
        // Loading symbol
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Sets current user to user
        let user = PFUser.current()
        
        // Receives user information from server
        // TODO - set up user information in core data
        let query = PFQuery(className: "Profile")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                self.displayAlert(title: "Error Occured", message: "Could not load profile")
            } else {
                
                if let objects = objects {
                    for object in objects {
                        if let newName = object["name"] as? String {
                            self.userName = newName
                        }
                        if let instagramName = object["instagram"] as? String {
                            self.userInstagram = instagramName
                        }
                        if let twitterName = object["twitter"] as? String {
                            self.userTwitter = twitterName
                        }
                        if let profPic = object["profilePicture"] as? PFFile {
                            self.userPic = profPic
                        }
                        if let username1 = object["username"] as? String {
                            self.userUsername = username1
                        }
                        if let snap = object["snapchat"] as? String {
                            self.userSnapchat = snap
                        }
                        if let fb = object["facebook"] as? String {
                            self.userFacebook = fb
                        }
                        if let bio = object["bio"] as? String {
                            self.userBio = bio
                        }
                        
                    }
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    self.performSegue(withIdentifier: "backToYourProfile", sender: self)
                }
                
            }
        }
        
    }
    
    
    
    var imageFile:PFFile?
    var currentUser = PFUser.current()
    var currentUsername = ""
    
    // Allows user to select a profile picture from their camera roll
    @IBAction func imageSelect(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        /* TODO
        if var image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = rotateImage(image: image)
            profilePicture.image = image
        }
        */
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var bioTextField: UITextField!
    @IBOutlet var snapchatTextField: UITextField!
    @IBOutlet var facebookTextField: UITextField!
    @IBOutlet var bannerView: GADBannerView!
    
    // Alert with no segue
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // Hide keyboard when touch detected
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // Saves new profile information on server
    @IBAction func save(_ sender: Any) {
        
        // Loading symbol
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        let user = PFUser.current()
        
        // Finds old user information on server to be deleted
        let oldQuery = PFQuery(className: "Profile")
        oldQuery.whereKey("user", equalTo: user)
        oldQuery.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                self.displayAlert(title: "Profile Not Updated", message: "Profile could not be saved")
            } else {
                // Deletes old profile information
                // Saves space on server
                if let objects = objects {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
            }
        }
        
        // Saves new information on server under current user
        let query = PFUser.query()
        query?.whereKey("user", equalTo: user)
        let update = PFObject(className: "Profile")
        update["user"] = user
        update["username"] = PFUser.current()?.username
        if let name = self.name.text {
            update["name"] = name
            userName = name
        }
        if let twitterHandle = self.twitter.text {
            let twitterHandle = twitterHandle.trimmingCharacters(in: .whitespacesAndNewlines)
            update["twitter"] = twitterHandle
            userTwitter = twitterHandle
        }
        if let instagramName = self.instagram.text {
            let instagramName = instagramName.trimmingCharacters(in: .whitespacesAndNewlines)
            update["instagram"] = instagramName
            userInstagram = instagramName
        }
        if let snapName = self.snapchatTextField.text {
            let snapName = snapName.trimmingCharacters(in: .whitespacesAndNewlines)
            update["snapchat"] = snapName
            userSnapchat = snapName
        }
        if let fbName = self.facebookTextField.text {
            let fbName = fbName.trimmingCharacters(in: .whitespacesAndNewlines)
            update["facebook"] = fbName
            userFacebook = fbName
        }
        if let bio = self.bioTextField.text {
            update["bio"] = bio
            userBio = bio
        }
        if let image = self.profilePicture.image {
            if let imageData = UIImagePNGRepresentation(image) {
                let imageFile = PFFile(name: "image.png", data: imageData)
                update["profilePicture"] = imageFile
                userPic = imageFile
            }
        }
        
        update.saveInBackground { (success, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if error != nil {
                self.displayAlert(title: "Profile Not Updated", message: "Profile could not be saved")
            } else {
                self.performSegue(withIdentifier: "backToYourProfile", sender: self)
            }
        }
        
    }
    
    @IBOutlet var instagram: UITextField!
    @IBOutlet var twitter: UITextField!
    @IBOutlet var name: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // Google Ads
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        */
        
        // Makes profile picture appear in a circle rather than square
        profilePicture.layer.borderWidth = 1
        profilePicture.layer.masksToBounds = false
        profilePicture.layer.borderColor = UIColor.black.cgColor
        profilePicture.layer.cornerRadius = profilePicture.frame.height/2
        profilePicture.clipsToBounds = true
        
        // Initially loads current user's information to allow for editing
        let user = PFUser.current()
        let initialQuery = PFQuery(className: "Profile")
        initialQuery.whereKey("user", equalTo: user)
        initialQuery.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.displayAlert(title: "Error", message: "Profile could not be loaded")
            } else {
                
                if let objects = objects {
                    for object in objects {
                        if let name = object["name"] as? String {
                            self.name.text = name
                        }
                        if let twitterHan = object["twitter"] as? String {
                            self.twitter.text = twitterHan
                        }
                        if let instagramUser = object["instagram"] as? String {
                            self.instagram.text = instagramUser
                        }
                        if let snapchatName = object["snapchat"] as? String {
                            self.snapchatTextField.text = snapchatName
                        }
                        if let facebookName = object["facebook"] as? String {
                            self.facebookTextField.text = facebookName
                        }
                        if let bio1 = object["bio"] as? String {
                            self.bioTextField.text = bio1
                        }
                        if let imageFile = object["profilePicture"] as? PFFile {
                            imageFile.getDataInBackground(block: { (data, error) in
                                if let imageData = data {
                                    if let imageToDisplay = UIImage(data: imageData) {
                                        self.profilePicture.image = imageToDisplay
                                    }
                                }
                            })
                        }
                    }
                }
                
            }
        }
        // If no profile picture is detected, a default image will be used
        if self.profilePicture.image == nil {
            self.profilePicture.image = #imageLiteral(resourceName: "defaultUser.png")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segues current user's information back to YourProfileViewController
        if let userProf = segue.destination as? YourProfileViewController {
            
            if let userName = userName {
                userProf.activeName = userName
            }
            if let userTwitter = userTwitter {
                userProf.twitter = userTwitter
            }
            if let userInsta = userInstagram {
                userProf.instagram = userInsta
            }
            if let userPic = userPic {
                userProf.profilePicture = userPic
            }
            if let userBio = userBio {
                userProf.bio1 = userBio
            }
            if let userUser = userUsername {
                userProf.userUsername = userUser
            }
            if let userSnap = userSnapchat {
                userProf.snapchat = userSnap
            }
            if let userFB = userFacebook {
                userProf.facebook = userFB
            }
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
