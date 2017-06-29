//
//  CreateViewController.swift
//  Instagram
//
//  Created by Maxine Kwan on 6/27/17.
//  Copyright © 2017 Maxine Kwan. All rights reserved.
//

import UIKit
import Parse

class CreateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    var postImage = UIImage(named: "imageName")
    var postCaption = ""
    var alertController = UIAlertController(title: "createActionController", message: "New Post", preferredStyle: .actionSheet)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.postImage == UIImage(named: "imageName") {
            present(alertController, animated: true)
        }
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
        imageView.image = resize(image: editedImage, newSize: CGSize(width: 640,height: 640))
        postImage = resize(image: editedImage, newSize: CGSize(width: 640,height: 640))
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
    
    @IBAction func onShare(_ sender: Any) {
        postCaption = captionField.text ?? ""
        Post.postUserImage(image: postImage, withCaption: postCaption) { (status: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Post successful")
                //Goes back to feed after posting
                self.tabBarController?.selectedIndex = 0
                //Reset photo selected
                self.postImage = UIImage(named: "imageName")
                self.postCaption = ""
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
