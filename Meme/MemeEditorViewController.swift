//
//  MemeEditorViewController.swift
//  Meme
//
//  Created by Sudeep Agrawal on 6/19/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextFieldDelegate
{
    
    //Outlets
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var topNavbar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    //Custom Variable
    var memes: [MemeModel]!
    var initialViewYPosition:CGFloat = 0.0
    var activeTextField : UITextField!
    
    let TAG_CAMERA_BUTTON:Int = 0
    let TAG_ALBUM_BUTTON:Int = 1
    
    let LABEL_TOP_TEXT:String = "TOP"
    let LABEL_BOTTOM_TEXT:String = "BOTTOM"
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true     // status bar should be hidden
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initializeMemeTexts(topText, labelText:LABEL_TOP_TEXT)
        initializeMemeTexts(bottomText, labelText:LABEL_BOTTOM_TEXT)
        
        //This seting will not stretch the image selected in the image view.
        imageView.contentMode = .ScaleAspectFit
    }
    
    func initializeMemeTexts(textField:UITextField , labelText:String)
    {
        let memeTextAttributes = [
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            //NSBackgroundColorAttributeName: UIColor.blackColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName:UIFont(name:"HelveticaNeue-CondensedBlack",size: 40)!,
            NSStrokeWidthAttributeName:-3.3
        ]
        
        //Set the text delegate to self so that the implemented methods can be self applied
        textField.delegate = self
        
        //Initialize Top and Bottom texts
        textField.text  = labelText
        
        //Initialize Text Attributes
        textField.defaultTextAttributes = memeTextAttributes
        
        //Text should be center-aligned, this is placed after the default memetext attributes are loaded in the textFields
        textField.textAlignment = .Center
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // initialize the  memes object from AppDelegate reference
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        initialViewYPosition = imageView.frame.origin.y
        
        //enable the camera button if the camera feature is available on the device
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        //enable share button only if there is an image assigned
        shareButton.enabled = (imageView.image != nil)
        
        //subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.showKeyboard(_:)), name: UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.hideKeyboard(_:)), name: UIKeyboardWillHideNotification, object:nil)
    }
    
    func unsubscribeToKeyboardNotifications()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object:nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object:nil)
    }
    
    func getKeyboardHeight(notification:NSNotification) -> CGFloat
    {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func showKeyboard(notification:NSNotification)
    {
        if bottomText.isFirstResponder()
        {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func hideKeyboard(notification:NSNotification)
    {
        if bottomText.isFirstResponder()
        {
            self.view.frame.origin.y = 0
        }
    }
    
    /*
     Function to pick an image from either the Photo Library / Camera.
     */
    @IBAction func pickAnImage(sender: AnyObject)
    {
        print("Button pressed: ", sender.tag)
        let pickController = UIImagePickerController();
        pickController.delegate = self
        
        switch sender.tag
        {
            case TAG_CAMERA_BUTTON: pickController.sourceType = UIImagePickerControllerSourceType.Camera
                                    break
            
            case TAG_ALBUM_BUTTON:  pickController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
                                    break
            
            default: break
        }
        self.presentViewController(pickController, animated: true, completion: nil)
    }
    
    @IBAction func shareButtonAction(sender: AnyObject)
    {
        let memeImage:UIImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
        //Ref: http://stackoverflow.com/questions/25644054/uiactivityviewcontroller-crashing-on-ios8-ipads
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        
        activityViewController.completionWithItemsHandler={
            (activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            // Return if cancelled
            if (!completed)
            {
                return
            }
            
            //Activity to save the image
            self.save()
            //then dismiss the view controller
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    /*
     Function to clear out the image view upon click and dismiss the Image Picker Controller
     */
    @IBAction func cancelButtonAction(sender: AnyObject)
    {
        imageView.image = nil
        shareButton.enabled=false
        topText.text = LABEL_TOP_TEXT
        bottomText.text = LABEL_BOTTOM_TEXT
        self.activeTextField = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Method implementation from UIImagePickerDelegate in order to access the photo selected 
    //from the camrea or the photo library. 
    //Upon selecting the image, the Image picker Controller must be dismissed
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        if let selectImage=info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            imageView.image = selectImage
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        //Ref:http://stackoverflow.com/questions/30918732/how-to-determine-which-textfield-is-active-swift/30918882
        activeTextField = textField
        if (self.activeTextField.text == LABEL_TOP_TEXT)    {topText.text = ""}
        if (self.activeTextField.text == LABEL_BOTTOM_TEXT) {bottomText.text = ""}
    }
    
    /*
     When the user pressed the Enter button the keyboard must be dismissed.
     Reference:http://stackoverflow.com/questions/24180954/how-to-hide-keyboard-in-swift-on-pressing-return-key
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func save()
    {
        //Create the meme
        let meme = MemeModel(topLabel:topText.text!, bottomLabel: bottomText.text!,originalImage: imageView.image!, savedMemeImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage
    {
        //TODO: Hide toolbar and Navbar
        topNavbar.hidden = true
        bottomToolbar.hidden = true
        
        //Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //TODO: Show toolbar and navbar
        topNavbar.hidden = false
        bottomToolbar.hidden = false
        
        return memedImage
    }
}