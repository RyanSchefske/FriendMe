//
//  SearchViewController.swift
//  FriendHub
//
//  Created by Ryan Schefske on 2/22/18.
//  Copyright © 2018 Ryan Schefske. All rights reserved.
//
//  Sets up search function in app

import UIKit
import Parse
import GoogleMobileAds

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // Alert with no segue
    func displayAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet var bannerView: GADBannerView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var table: UITableView!
    
    // Declare variables
    var searchResults = [String]()
    var nameResults = [String]()
    
    var names = [String]()
    var usernames = [String]()
    
    var activePlace = -1
    var activeUser: String?
    var activeName: String?
    var twitterHandle: String?
    var instagramName: String?
    var facebookName: String?
    var snapName: String?
    var bio: String?
    var profilePicture: PFFile?
    var activeUsername: String?
    
    // Brings user back to home screen
    @IBAction func cancelButton(_ sender: Any) {
        
        // Loading symbol
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Regathers information for home screen
        // TODO - More efficient way of doing this (possibly using coreData)
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
                self.performSegue(withIdentifier: "fromSearchScreen", sender: self)
            }
        })
        
    }
    
    // Displays only necessary amount of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Initializes reusable cell as "cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomSearchTableViewCell
        
        // Slightly curves the edges of the cells
        cell.cellView.layer.cornerRadius = cell.cellView.frame.height / 2
        
        // Displays user's name and username in respective cells
        cell.nameLabel.text = nameResults[indexPath.row]
        cell.profileLabel.text = searchResults[indexPath.row] //usernames
        
        // Profile pictures appear circular
        cell.profilePicture.layer.borderWidth = 1
        cell.profilePicture.layer.masksToBounds = false
        cell.profilePicture.layer.borderColor = UIColor.black.cgColor
        cell.profilePicture.layer.cornerRadius = cell.profilePicture.frame.height/2
        cell.profilePicture.clipsToBounds = true
        
        // Separate query for getting profile pictures for each user
        // TODO - More efficient way of doing this
        let imageQuery = PFQuery(className: "Profile")
        imageQuery.whereKey("username", equalTo: self.searchResults[indexPath.row])
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
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     
        // Removes search results when searchBar is cleared
        if searchBar.text == "" {
            self.nameResults.removeAll()
            self.searchResults.removeAll()
        }
        
        // Removes search results when search is changed
        self.searchResults.removeAll()
        self.nameResults.removeAll()
        
        // Sets up two queries to find users based on either name or username
        // Allows users to search based on names or usernames
        let nameQuery = PFQuery(className: "Profile")
        nameQuery.whereKey("name", contains: searchBar.text)
        
        let usernameQuery = PFQuery(className: "Profile")
        usernameQuery.whereKey("username", contains: searchBar.text)
        
        let query = PFQuery.orQuery(withSubqueries: [nameQuery,usernameQuery])
        
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil {
                self.displayAlert(title: "Error", message: "Search did not work")
            } else {
                if let objects = objects {
                    self.searchResults.removeAll(keepingCapacity: false)
                    
                    for object in objects {
                        let name = object["name"] as! String
                        let username = object["username"] as! String
                        self.searchResults.append(username)
                        self.nameResults.append(name)
                    }
                    
                }
            }
            self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Sets active user to selected user
        activePlace = indexPath.row
        activeUser = searchResults[activePlace]
        
        // Loading symbol
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        // Finds user information based on who was selected for segue to ProfileViewController
        let query = PFQuery(className: "Profile")
        if activeUser != nil {
            
            query.whereKey("username", equalTo: activeUser)
            query.findObjectsInBackground(block: { (objects, error) in
                
                if error != nil {
                    print(error)
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
                    
                    self.performSegue(withIdentifier: "toProfileFromSearch", sender: self)
                }
                
            })
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Passes selected user's information to ProfileViewController
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
        
        // Ran into an issue with HomeTableViewController not loading properly when segued from search bar
        // This fixed this issue
        if segue.identifier == "fromSearchScreen"{
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        // Google Ads
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        */
        
        table.delegate = self
        table.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

}
