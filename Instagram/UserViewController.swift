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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refresh Control Initialized
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        collectionView.insertSubview(refreshControl, at: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        refresh()

        // Do any additional setup after loading the view.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refresh()
        refreshControl.endRefreshing()
    }
    
    func refresh() {
        var feedPosts: [PFObject] = []
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
