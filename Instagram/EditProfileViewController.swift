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

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var userView: PFImageView!
    var postImage = UIImage(named: "imageName")
    var alertController = UIAlertController(title: "createActionController", message: "Change Profile Picture", preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        if  let user = PFUser.current() {
            
            // Upload new profile picture
            if let image = Post.getPFFileFromImage(image: postImage) {
                //user.setObject(image, forKey: "image")
                user["image"] = image
                user.saveInBackground(block: { (success, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if success {
                        print("Profile picture uploaded")
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    
    func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}





/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */


