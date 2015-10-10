//
//  EditWaypointViewController.swift
//  Trax
//
//  Created by Jose Luis Lucini Reviriego on 6/10/15.
//  Copyright © 2015 JLLucini. All rights reserved.
//

import UIKit
import MobileCoreServices

class EditWaypointViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var nameTextField: UITextField! {
        didSet { nameTextField.delegate = self }
    }
    @IBOutlet weak var infoTextField: UITextField!{
        didSet { infoTextField.delegate = self }
    }
    
    // MARK: - Public API
    // The model for this VC
    var waypointToEdit: EditableWaypoint? {
        didSet { updateUI()}
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        updateUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        observeTextFields() // This is to have the model in sync
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingTextFields()
    }
    
    // MARK: - View Aux Functions
    
    func updateUI(){
        nameTextField?.text = waypointToEdit?.name
        infoTextField?.text = waypointToEdit?.info
        updateImage()
    }

    @IBAction func done(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Image
    
    var imageView = UIImageView()
    
    @IBOutlet weak var imageViewContainer: UIView! {
        didSet {
            imageViewContainer.addSubview(imageView)
        }
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            picker.sourceType = .Camera
            // if we were looking for video, we'd check availableMediaTypes
            picker.mediaTypes = [kUTTypeImage as String]
            picker.delegate = self
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        } else {
            picker.sourceType = .PhotoLibrary
            // if we were looking for video, we'd check availableMediaTypes
            picker.allowsEditing = false
        }
        picker.mediaTypes = [kUTTypeImage as String]
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        imageView.image = image
        makeRoomForImage()
        saveImageInWaypoint()
        // We are the presentingViewController, so just dismiss view
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImageInWaypoint(){
        if let image = imageView.image {
            if let imageData = UIImageJPEGRepresentation(image, 1.0){
                let fileManager = NSFileManager()
                if let docsDir  = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first {
                    let unique = NSDate.timeIntervalSinceReferenceDate()
                    let url    = docsDir.URLByAppendingPathComponent("\(unique).jpg")
                    let path   = url.absoluteString
                    if imageData.writeToURL(url, atomically: true){
                        waypointToEdit?.links = [GPX.Link(href: path)]
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Text fields Delegates
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()  // This hides the keyboard
        return true
    }
    
    
    
    // MARK: - Text fields Notifications
    
    // Needed to releade the observer when the MVC is gone
    private var ntfObserver: NSObjectProtocol?
    private var itfObserver: NSObjectProtocol?
    
    func observeTextFields(){
        let center  = NSNotificationCenter.defaultCenter()
        let queue   = NSOperationQueue.mainQueue()
        ntfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: nameTextField, queue: queue) { notification in
            if let waypoint = self.waypointToEdit {
                waypoint.name = self.nameTextField.text
            }
        }
        
        itfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: infoTextField, queue: queue) { notification in
            if let waypoint = self.waypointToEdit {
                waypoint.info = self.infoTextField.text
            }
        }
    }
    
    private func stopObservingTextFields()
    {
        if let observer = ntfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
        if let observer = itfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
}

extension EditWaypointViewController
{
    func updateImage() {
        if let url = waypointToEdit?.imageURL {
            let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
            dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                if let imageData = NSData(contentsOfURL: url) {
                    if url == self?.waypointToEdit?.imageURL {
                        if let image = UIImage(data: imageData) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self?.imageView.image = image
                                self?.makeRoomForImage()
                            }
                        }
                    }
                }
            }
        }
    }
    
    // all we do in makeRoomForImage() is adjust our preferredContentSize
    // we assume that our preferredContentSize is what is currently desired (pre-adjustment)
    // then we adjust it to make up for any differences in the size of our image view or its container
    // if our preferredContentSize change can be accomodated, our container will get taller
    // and more of our image will show
    // if not, we tried our best to show as much of the image as possible
    // because we use the entire width of our container view and
    // show an appropriate height depending on our image's aspect ratio
    // this is sort of a "quick and dirty" way to do this
    // in a real application, one would probably want to be more exacting here
    // (perhaps apply more sophisticated autolayout to the problem)
    
    func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if imageView.image?.aspectRatio > 0 {
            if let width = imageView.superview?.frame.size.width {
                let height = width / imageView.image!.aspectRatio
                extraHeight = height - imageView.frame.height
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -imageView.frame.height
            imageView.frame = CGRectZero
        }
        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
