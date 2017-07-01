//
//  PostCell.swift
//  Instagram
//
//  Created by Maxine Kwan on 6/28/17.
//  Copyright © 2017 Maxine Kwan. All rights reserved.
//

import UIKit
import Parse
import ParseUI

@objc protocol PostCellDelegate {
    func postCell(_ cell: PostCell, didLike post: PFObject?)
}

class PostCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var photoView: PFImageView!
    @IBOutlet weak var userView: PFImageView!
    @IBOutlet weak var userLabel2: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
//    var liked = false
      weak var delegate: PostCellDelegate?
    
    var feedPost: PFObject?
    //{
//        didSet {
//            let post = feedPost!
//            let likes = post["likesCount"] as! Int
//            likesLabel.text = "\(likes)"
//        }
  // }
    
    
    @IBAction func didTapLikeButton(_ sender: Any) {
        delegate?.postCell(self, didLike: feedPost)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//        let post = feedPost!
//        var likes = post["likesCount"] as! Int
//        
//        if liked == false {
//            likes += 1
//            likeButton.setImage(UIImage(named: "liked"), for: .normal)
//        } else {
//            likes -= 1
//            likeButton.setImage(UIImage(named: "like"), for: .normal)
//        }
//        liked = !liked
//        post["likesCount"] = likes
//        post.saveInBackground()
//        likesLabel.text = "\(likes)"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Sets circle profile picture viewer
        userView.layer.borderWidth = 1
        userView.layer.masksToBounds = false
        userView.layer.borderColor = UIColor.white.cgColor
        userView.layer.cornerRadius = userView.frame.height/2
        userView.clipsToBounds = true
    }


}
