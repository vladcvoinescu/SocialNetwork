//
//  SettingsVC.swift
//  SocialNetwork
//
//  Created by Voinescu, Vlad on 12/14/15.
//  Copyright © 2015 BearingPoint. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    var defaultPicture: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: "selectImage:")
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        profileImage.image = image
        defaultPicture = false
    }
    
    func selectImage(sender: UITapGestureRecognizer) {
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelTap(sender: AnyObject!) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func saveTap(sender: AnyObject!) {
        
        if defaultPicture == nil || nameField.text == nil {
            
            showErrorAlert("Error", msg: "Please add your display picture and your display name.");
            
        } else {
            
            // update user name and user picture
            
            self.navigationController?.popViewControllerAnimated(true)
            
        }
        
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
    
}
