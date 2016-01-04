//
//  PostCell.swift
//  SocialNetwork
//
//  Created by Voinescu, Vlad on 12/8/15.
//  Copyright © 2015 BearingPoint. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class PostCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var showcaseImg: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var likeImg: UIImageView!
    
    var post: Post!
    var request: Request?
    var likeRef: Firebase!
    var userRef: Firebase!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: "likeTapped:")
        tap.numberOfTapsRequired = 1
        likeImg.addGestureRecognizer(tap)
    }
    
    override func drawRect(rect: CGRect) {
        profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
        profileImg.clipsToBounds = true
        
        showcaseImg.clipsToBounds = true
    }
    
    func configureCell(post: Post, img: UIImage?) {
        
//        self.likeImg.hidden = true
        self.post = post
        likeRef = DataService.ds.REF_USER_CURRENT.childByAppendingPath("likes").childByAppendingPath(post.postKey)
        
        self.descriptionText.text = post.postDescription
        self.likesLbl.text = "\(post.likes)"
        
        if post.imageUrl != nil {
            
            if img != nil {
                self.showcaseImg.image = img
                self.showcaseImg.hidden = false
            } else {
                
                request = Alamofire.request(.GET, post.imageUrl!).validate(contentType: ["image/*"]).response(completionHandler: {
                    request, reponse, data, err in
                    
                    if err == nil {
                        let img = UIImage(data: data!)!
                        self.showcaseImg.image = img
                        self.showcaseImg.hidden = false
                        FeedVC.imageCache.setObject(img, forKey: self.post.imageUrl!)
                    } else {
                        print(err.debugDescription)
                    }
                })
                
            }
            
        } else {
            self.showcaseImg.hidden = true
        }
        
        likeRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            
            print("observeSingleEventOfType fron configureCell")
            
            if let _ = snapshot.value as? NSNull {
                // This means we have not liked this specific post
                self.likeImg.image = UIImage(named: "heart-empty")
//                self.likeImg.hidden = false
            } else {
                self.likeImg.image = UIImage(named: "heart-full")
//                self.likeImg.hidden = false
            }
            
        })
        
    }
    
    func likeTapped(sender: UITapGestureRecognizer) {
        
        self.likeImg.userInteractionEnabled = false
        
        likeRef.observeSingleEventOfType(.Value, withBlock: {snapshot in
            
            print("observeSingleEventOfType fron likeTapped")
            
            if let _ = snapshot.value as? NSNull {
                // This means we have not liked this specific post
                //self.likeImg.image = UIImage(named: "heart-full")     // the observeSingleEventOfType fron configureCell is sufficient. cellAtIndexPath gets called when tap
                self.post.adjustLikes(true)
                self.likeRef.setValue(true)
            } else {
                //self.likeImg.image = UIImage(named: "heart-empty")    // the observeSingleEventOfType fron configureCell is sufficient. cellAtIndexPath gets called when tap
                self.post.adjustLikes(false)
                self.likeRef.removeValue()
            }
            
            self.likeImg.userInteractionEnabled = true
            
        })
    }
    
}
