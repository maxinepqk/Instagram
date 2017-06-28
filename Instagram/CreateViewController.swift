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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.postImage == UIImage(named: "imageName") {
            launchImagePicker()
        }
    }
    
    func launchImagePicker(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            imagePicker.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            imagePicker.sourceType = .photoLibrary
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        imageView.image = editedImage
        postImage = editedImage
        dismiss(animated: true, completion: nil)
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
