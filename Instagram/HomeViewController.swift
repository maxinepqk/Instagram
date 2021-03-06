//
//  HomeViewController.swift
//  Instagram
//
//  Created by Maxine Kwan on 6/27/17.
//  Copyright © 2017 Maxine Kwan. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PostCellDelegate {
    
    var feedPosts: [PFObject] = []
    @IBOutlet weak var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refresh Control Initialized
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.separatorStyle = .none
        
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
        query.limit = 20
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                if let posts = posts {
                    for post in posts {
                        feedPosts.append(post)
                    }
                    self.feedPosts = feedPosts
                    self.tableView.reloadData()
                    print("Feed reloaded")
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.loggingOut()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
//        cell.delegate = self as? PostCellDelegate
        let post = feedPosts[indexPath.row]
//        cell.feedPost = post
        
        
        // in cell
        
        let caption = post["caption"] as! String
        let image = post["media"] as! PFFile
        let author = post["author"] as! PFUser
        let likeCount = post["likesCount"] as! Int
        //cell.likeButton.tag = indexPath.row
        
//      let likes = post["likesCount"] as? Any
//      if type(of: likes) == type(of: Int()) {
//          let likeCount = "0"
//      }
//      else {
//          let likeCount = (likes as? Array)?.count
//      }
        
        cell.likesLabel.text = String(likeCount)
        cell.captionLabel.text = caption
        cell.photoView.file = image
        cell.photoView.loadInBackground()
        cell.userLabel.text = author.username
        cell.userLabel2.text = author.username
        cell.userView.file = author["image"] as? PFFile
        cell.userView.loadInBackground()
        
        // Liking
//      on like, add current user to list of users who liked the post and change the displayed icon by pulling from API
//     post["likesCount"].append(PFUser.Current())
//     
        
        return cell
    }
    
    func postCell(_ cell: PostCell, didLike post: PFObject?) {
        print("hi")
        let indexPath = tableView.indexPath(for: cell)!
        let post = feedPosts[indexPath.row]
        let likes = (post["likesCount"] as? Int)! + 1
        post["likesCount"] = likes
        post.saveInBackground()
        cell.likeButton.isSelected = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell) {
            let post = feedPosts[indexPath.row]
            let detailsViewController = segue.destination as! DetailsViewController
            detailsViewController.post = post
        }
    }

}
