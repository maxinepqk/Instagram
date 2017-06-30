//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Maxine Kwan on 6/28/17.
//  Copyright © 2017 Maxine Kwan. All rights reserved.
//

import UIKit
import Parse
import ParseUI

let updatedProfileNotif = "com.maxine.EditProfileViewController.didUpdateProfile"

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var userView: PFImageView!
    var postImage = UIImage(named: "imageName")
    var alertController = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var bioField: UITextField!
    var invalidUsernameAlertController = UIAlertController(title: "Username is already taken", message: "The username you entered is already taken. Please enter a new one and try again.", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .cancel) { (action) in
        }
        invalidUsernameAlertController.addAction(tryAgainAction)
        
        [nameField, usernameField, bioField].map { $0?.delegate = self }

        // Sets circle profile picture viewer
        userView.layer.borderWidth = 1
        userView.layer.masksToBounds = false
        userView.layer.borderColor = UIColor.black.cgColor
        userView.layer.cornerRadius = userView.frame.height/2
        userView.clipsToBounds = true
        
        //Creates action sheet for creating post options
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.launchImagePicker(source: .camera)
        }
        alertController.addAction(takePhotoAction)
        let importAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.launchImagePicker(source: .photoLibrary)
        }
        alertController.addAction(importAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.tabBarController?.selectedIndex = 0
        }
        alertController.addAction(cancelAction)
        
        // Update profile info with existing info
        if let user = PFUser.current(){
            usernameField.text = user.username
            // needs to check if exists
            bioField.text = user["bio"] as? String
            nameField.text = user["name"] as? String
            userView.file = user["image"] as? PFFile
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    func launchImagePicker(source: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if source == .camera {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                print("Camera is available 📸")
                imagePicker.sourceType = .camera
            } else {
                // add alert here to say camera not available
                print("Camera 🚫 available so we will use photo library instead")
                imagePicker.sourceType = .photoLibrary
            }
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        _ = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        userView.image = resize(image: editedImage, newSize: CGSize(width: 128,height: 128))
        postImage = resize(image: editedImage, newSize: CGSize(width: 128,height: 128))
        dismiss(animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @IBAction func onChangePic(_ sender: Any) {
        present(alertController, animated: true)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDone(_ sender: Any) {
        if let user = PFUser.current() {
            
            // Upload new profile picture
            if let image = Post.getPFFileFromImage(image: postImage) {
                user["image"] = image
                user.saveInBackground(block: { (success: Bool?, error: Error?) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        print("Profile picture uploaded")
                        // broadcast a message called "asiljfhs" to UserVC (using NSNotificationCenter) to tell UserVC to refreshProfileInfo()
                    }
                })
            }
            user["bio"] = bioField.text
            user["name"] = nameField.text
            user.username = usernameField.text // print error
            user.saveInBackground(block: { (success: Bool, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                    let code = (error as NSError).code
                    if code == 202 {
                        self.present(self.invalidUsernameAlertController, animated: true)
                    }
                } else {
                    print("Profile updated")
                }
            })
        }
        //Fix NS notif
        let selectionInfo: [NSObject : AnyObject] = [:]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: updatedProfileNotif), object: self, userInfo: selectionInfo)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}



