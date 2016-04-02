//
//  ImageCapture.swift
//  AppConnectSwift
//
//  Created by Suman Sucharit Das on 4/1/16.
//  Copyright © 2016 Medidata Solutions. All rights reserved.
//

import UIKit
import MobileCoreServices

class VideoCapture: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var formID : String!
    let saveFileName = "/test.mp4"
    var myPickerController = UIImagePickerController()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectImage: UIButton!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var videoPath: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func doLogout() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func recordVideo(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                
                myPickerController.sourceType = .Camera
                myPickerController.mediaTypes = [kUTTypeMovie as String]
                myPickerController.allowsEditing = false
                myPickerController.delegate = self
                
                presentViewController(myPickerController, animated: true, completion: {})
            } else {
                postAlert("Rear camera doesn't exist", message: "Application cannot access the camera.")
            }
        } else {
            postAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func uploadTapped(sender: AnyObject) {
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("Got a video")
        
        if let pickedVideo:NSURL = (info[UIImagePickerControllerMediaURL] as? NSURL) {
            // Save video to the main photo album
            let selectorToCall = Selector("videoWasSavedSuccessfully:didFinishSavingWithError:context:")
            UISaveVideoAtPathToSavedPhotosAlbum(pickedVideo.relativePath!, self, selectorToCall, nil)
            
            // Save the video to the app directory so we can play it later
            let videoData = NSData(contentsOfURL: pickedVideo)
            let paths = NSSearchPathForDirectoriesInDomains(
                NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentsDirectory: AnyObject = paths[0]
            let dataPath = documentsDirectory.stringByAppendingPathComponent(saveFileName)
            videoData?.writeToFile(dataPath, atomically: false)
            let videoPathURL = info[UIImagePickerControllerMediaURL] as? NSURL
            videoPath.text = videoPathURL?.absoluteString
        }
        
        myPickerController.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an video
        })
    }
    
    // Called when the user selects cancel
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
        })
    }
    
    func postAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}


