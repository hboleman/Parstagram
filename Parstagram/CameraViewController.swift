//
//  CameraViewController.swift
//  Parstagram
//
//  Created by Hunter Boleman on 3/23/19.
//  Copyright © 2019 Hunter Boleman. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        let post = PFObject(className: "Posts");
        
        post["caption"] = commentField.text!;
        post["author"] = PFUser.current()!;
        
        // Makes bonary object from photo
        let imageData = imageView.image!.pngData();
        let file = PFFileObject(data: imageData!)
        
        // save image binary to post
        post["image"] = file;
        
        
        post.saveInBackground { (success, error) in
            if (success) {
                print("Saved!");
                self.dismiss(animated: true, completion: nil);
            }
            else{
                print("ERROR: not saved in background!");
            }
        }
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        // Simple way to do photo
        let picker = UIImagePickerController();
        picker.delegate = self;
        picker.allowsEditing = true;
        
        // Check if camera available
        if (UIImagePickerController.isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera;
        }
            // For use in simulator
        else {
            picker.sourceType = .photoLibrary;
        }
        present(picker, animated: true, completion: nil);
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage;
        
        // Resize Image
        let size = CGSize(width: 300, height: 300);
        let scaledImage = image.af_imageScaled(to: size);
        
        // Put scaled image inside view window
        imageView.image = scaledImage;
        
        // Dismiss Camera View
        dismiss(animated: true, completion: nil);
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
