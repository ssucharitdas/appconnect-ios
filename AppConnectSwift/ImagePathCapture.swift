//
//  ImageCapture.swift
//  AppConnectSwift
//
//  Created by Suman Sucharit Das on 4/1/16.
//  Copyright © 2016 Medidata Solutions. All rights reserved.
//

import UIKit

class ImagePathCapture: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var formID : String!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var imagePath: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func doLogout() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func uploadTapped(sender: AnyObject) {
    }
    
    @IBAction func selectButtonTapped(sender: AnyObject) {
        var myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let imagePathURL = info[UIImagePickerControllerReferenceURL] as? NSURL
        imagePath.text = imagePathURL?.absoluteString
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
}


