//
//  HomeViewController.swift
//  Instagram
//
//  Created by Maxine Kwan on 6/27/17.
//  Copyright © 2017 Maxine Kwan. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController{
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Refresh Control Initialized
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        //tableView.insertSubview(refreshControl, at: 0)
        
        // Do any additional setup after loading the view.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        refresh()
    }
    
    func refresh() {
        var query = PFQuery(className: "Post")
        query.getObjectInBackground(withId: "helloinstagram") { (post: PFObject?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                //tableViewReloadDAta
                print("Feed reloaded")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
                self.dismiss(animated: true, completion: nil)
                print("Logout successful")
            }
        }
    }

}
