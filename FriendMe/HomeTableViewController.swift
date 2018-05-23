//
//  HomeTableViewController.swift
//  FriendHub
//
//  Created by Ryan Schefske on 2/17/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class HomeTableViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // Alert with no segue
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet var tableName: UILabel!
    
    // TODO - Create Multiple rows on Home Screen
    var rowHeaders = ["Suggested", "Recent", "Sponsored"]
    
    // Declare variables
    var usernames = [String?]()
    var names = [String?]()
    var pictures = [UIImage]()
    var activePlace = -1
    var activeUser:String?
    var activeName:String?
    var instagramName:String?
    var twitterHandle:String?
    var snapName:String?
    var facebookName:String?
    var profilePicture:PFFile?
    var bio:String?
    var activeUsername:String?
    
    var userName:String?
    var userTwitter:String?
    var userInstagram:String?
    var userSnapchat:String?
    var userFacebook:String?
    var userPic:PFFile?
    var userUsername:String?
    var userBio:String?
    
    let cellSpacingHeight: CGFloat = 5
    
    // Gather user's information when profile button is clicked
    @IBAction func profileButton(_ sender: Any) {
        
        // Loading symbol
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Set user to current user
        let user = PFUser.current()
        
        // Gathers user information from server for segue
        let query = PFQuery(className: "Profile")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                PFUser.logOut()
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
                        if let snapName = object["snapchat"] as? String {
                            self.userSnapchat = snapName
                        }
                        if let fbName = object["facebook"] as? String {
                            self.userFacebook = fbName
                        }
                        if let userBio1 = object["bio"] as? String {
                            self.userBio = userBio1
                        }
                        if let profPic = object["profilePicture"] as? PFFile {
                            self.userPic = profPic
                        }
                        if let username1 = object["username"] as? String {
                            self.userUsername = username1
                        }
                    }
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    self.performSegue(withIdentifier: "showUserProfile", sender: self)
                }
                
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Created header to table row
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Suggested"
    }

    // Initializes reusable cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier") as! HomeProfileTableViewCell
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usernames.count
    }
    
    // Displays information for each cell in home screen in an UICollectionView
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! HomeCollectionViewCell
        
        // Uses parallel arrays to display proper username and name for each cell
        cell.nameOutlet.text = self.names[indexPath.row]
        cell.usernameOutlet.text = self.usernames[indexPath.row]
        
        // Allows profile pictures to appear circular
        cell.profilePicture.layer.borderWidth = 1
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.layer.borderColor = UIColor.black.cgColor
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height/2
        cell.profilePicture.clipsToBounds = true
        
        // Getting profile pictures from server after
        // TODO - Look into more efficient way of getting profile pictures (too slow)
        let imageQuery = PFQuery(className: "Profile")
        imageQuery.whereKey("username", equalTo: self.usernames[indexPath.row])
        imageQuery.findObjectsInBackground { (object, error) in
            if error != nil {
                self.displayAlert(title: "Error", message: "There was an error receiving profile pictures.")
            } else {
                if let object = object {
                    for objects in object {
                        if objects["profilePicture"] == nil {
                            cell.profilePicture.image = #imageLiteral(resourceName: "defaultUser.png")
                        }
                        if let image = objects["profilePicture"] as? PFFile{
                            if let imageFile = image as? PFFile {
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if let imageData = data {
                                        if let imageToDisplay = UIImage(data: imageData) {
                                            cell.profilePicture.image = imageToDisplay
                                        }
                                    }
                                })
                            }
                        }
                        
                    }
                }
            }
            // Reloads table data when profile pictures are received
            self.tableView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Sets active user to whoever was selected
        activePlace = indexPath.row
        activeUser = usernames[indexPath.row]
        
        // Loading symbol
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Gets selected user's information from server
        let query = PFQuery(className: "Profile")
        if activeUser != nil {
            
            query.whereKey("username", equalTo: activeUser)
            query.findObjectsInBackground(block: { (objects, error) in
                
                if error != nil {
                    self.displayAlert(title: "Error", message: (error?.localizedDescription)!)
                } else {
                    
                    if let objects = objects {
                        
                        for object in objects {
                            
                            if let nameNext = object["name"] as? String {
                                self.activeName = nameNext
                            }
                            if let twitterHan = object["twitter"] as? String {
                                self.twitterHandle = twitterHan
                            }
                            if let instagramUsr = object["instagram"] as? String {
                                self.instagramName = instagramUsr
                            }
                            if let snap = object["snapchat"] as? String {
                                self.snapName = snap
                            }
                            if let fb = object["facebook"] as? String {
                                self.facebookName = fb
                            }
                            if let profPic = object["profilePicture"] as? PFFile {
                                self.profilePicture = profPic
                            }
                            if let bio1 = object["bio"] as? String {
                                self.bio = bio1
                            }
                            if let selectedUsername = object["username"] as? String {
                                self.activeUsername = selectedUsername
                            }
                            
                        }
                        
                    }
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    self.performSegue(withIdentifier: "profileClicked", sender: self)
                }
                
            })
            
        } 
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Passes information of selected user to ProfileViewController
        if let destination = segue.destination as? ProfileViewController {
            if let name = activeName {
                destination.activeUser = name
            }
            if let twitter = twitterHandle {
                destination.twitterHandle = twitter
            }
            if let instagram =  instagramName {
                destination.instagramName = instagram
            }
            if let snapchat = snapName {
                destination.snapName = snapchat
            }
            if let fbName = facebookName {
                destination.facebookName = fbName
            }
            if let picture = profilePicture {
                destination.profilePicture = picture
            }
            if let bio1 = bio {
                destination.bio = bio1
            }
            if let username1 = activeUsername {
                destination.activeUsername = username1
            }
        }
        
        // Passes user's information to YourProfileViewController
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
            if let userSnap = userSnapchat {
                userProf.snapchat = userSnap
            }
            if let userFB = userFacebook {
                userProf.facebook = userFB
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
            
        }
        
    }

}
