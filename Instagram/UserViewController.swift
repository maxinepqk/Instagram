//
//  UserViewController.swift
//  Instagram
//
//  Created by Maxine Kwan on 6/28/17.
//  Copyright © 2017 Maxine Kwan. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class UserViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var refreshControl: UIRefreshControl!
    var feedPosts: [PFObject] = []
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var userView: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refresh Control Initialized
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Sets circle profile picture viewer
        userView.layer.borderWidth = 1
        userView.layer.masksToBounds = false
        userView.layer.borderColor = UIColor.white.cgColor
        userView.layer.cornerRadius = userView.frame.height/2
        userView.clipsToBounds = true
        
        refresh()
        // Do any additional setup after loading the view.
        
        
        // use NSNC to listen to broadcast messages titled "asiljfhs", when anyone broadcasts a message called "asiljfhs", then call refreshProfileInfo()
    }
    
    func refreshProfileInfo() {
        if let user = PFUser.current(){
            userLabel.text = user.username
            nameLabel.text = user["name"] as? String
            bioLabel.text = user["bio"] as? String
            self.title = user.username// sets navBar title
            userView.file = user["image"] as? PFFile
            userView.loadInBackground()
        }
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refresh()
        refreshControl.endRefreshing()
    }
    
    
    func refresh() {
        var feedPosts: [PFObject] = []
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.whereKey("author", equalTo: PFUser.current())
        query.includeKey("author")
        // limit to current author
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let posts = posts {
                    for post in posts {
                        feedPosts.append(post)
                    }
                    self.feedPosts = feedPosts
                    self.collectionView.reloadData()
                    print("Feed reloaded")
                }
            }
        }
        refreshProfileInfo()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userPhotoCell", for: indexPath) as! UserPhotoCell
        let post = feedPosts[indexPath.item]
        let image = post["media"] as! PFFile
        cell.photoView.file = image
        cell.photoView.loadInBackground()
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // check ifsegueidentifier
        if segue.identifier == "detailSegue" {
            let cell = sender as! UICollectionViewCell
            if let indexPath = collectionView.indexPath(for: cell) {
                let post = feedPosts[indexPath.item]
                let detailsViewController = segue.destination as! DetailsViewController
                detailsViewController.post = post
            }
        }
        // fix segue to edit profile
    }

}
