
//
//  imagesPickManager.swift
//  Burbank
//
//  Created by Madhusudhan on 17/03/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit


class imagesPickManager: NSObject , UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var displayImageView : UIImageView!
    
    var myPickerController = UIImagePickerController()
    
    var imageBaseString = ""
    
   // var appDelegate = UIApplication.shared.delegate as! AppDelegate

    var compressedImageData : NSData!
    var profilePicURLString = ""
    var didFinishPickingImage : ((UIImage)->())?
    class var sharedInstance: imagesPickManager {
        struct Singleton {
            static let instance = imagesPickManager()
        }
        return Singleton.instance
    }
    
    // MARK: Profile ImageView
    func applyCornerRadiusForProfilePic (imageView : UIImageView)
    {
        imageView.layer.cornerRadius=imageView.frame.size.width/2
        imageView.clipsToBounds=true
        
//        imageView.layer.borderColor=UIColor.white.cgColor
//        imageView.layer.borderWidth=1.0
    }
    
    
    // MARK: image retrieving from camera/ Gallery
    func cameraOptionOpen(imageView : UIImageView, button : UIButton, view : UIView)
    {
        myPickerController.delegate = self
        
        displayImageView = imageView
        
        /// Action sheet for showing options
        
        /// 1. select image from gallery 2. Take picture from Camera
        
        let settingsActionSheet: UIAlertController = UIAlertController(title:nil, message:nil, preferredStyle:UIAlertController.Style.actionSheet)
        settingsActionSheet.addAction(UIAlertAction(title:"Take Picture", style:UIAlertAction.Style.default, handler:{ action in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                /**
                 *  ImagePicker controller Camera type
                 */
                self.myPickerController.sourceType = .camera
                
                currentWindow.rootViewController!.present(self.myPickerController, animated: true, completion: nil)
            }
            
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Open Gallery", style:UIAlertAction.Style.default, handler:{ action in
            
            /**
             *  ImagePicker controller Gallery type
             */
            self.myPickerController.sourceType = .photoLibrary
            currentWindow.rootViewController!.present(self.myPickerController, animated: true, completion: nil)
        }))
        settingsActionSheet.addAction(UIAlertAction(title:"Cancel", style:UIAlertAction.Style.cancel, handler:nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad
        {
            let popPresenter : UIPopoverPresentationController = settingsActionSheet.popoverPresentationController!
            popPresenter.sourceView = view
            popPresenter.sourceRect = view.bounds;
            
            currentWindow.rootViewController!.present(settingsActionSheet, animated:true, completion:nil)
        }
        else
        {
            currentWindow.rootViewController!.present(settingsActionSheet, animated:true, completion:nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        /**
         Set the picture with respective profile picture imageview
         
         - parameter completion: Dismiss the imagePickercontroller layer
         */
        
        compressedImageData = compressImage(image: (info[.originalImage] as? UIImage)!)
        
        Base64.initialize()
        
        imageBaseString = Base64.encode(compressedImageData as Data)
        
        profilePicService()
        
        currentWindow.rootViewController!.dismiss(animated: true, completion: nil)

        }
    
    func compressImage(image : UIImage) -> NSData {
        var  imageData = (image.jpegData(compressionQuality: 0.0))!
        let image = UIImage(data: imageData)
        
        NSLog("Size of Image(bytes):%d",imageData.count / 1024);
        
        var actualHeight: CGFloat = image!.size.height
        var actualWidth: CGFloat = image!.size.width
        let maxHeight: CGFloat = 568.0//1136.0
        let maxWidth: CGFloat = 320.0//640.0
        var imgRatio: CGFloat = actualWidth / actualHeight
        let maxRatio: CGFloat = maxWidth / maxHeight
        var compressionQuality: CGFloat = 0.0
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
                compressionQuality = 0.0;
            }
        }
        
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: actualWidth, height: actualHeight)
        UIGraphicsBeginImageContext(rect.size)
        image!.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext();
        imageData = (img?.jpegData(compressionQuality: compressionQuality))! //UIImageJPEGRepresentation(img!, compressionQuality)!;
        UIGraphicsEndImageContext();
        
        NSLog("Size of COMPRESSED Image(bytes):%d",imageData.count / 1024);
        
        return imageData as NSData
    }
    
    // Service call for profile pic update
    func profilePicService() {
        
        let userID = appDelegate.currentUser?.userDetailsArray?[0].id
        
        let postDic = ["UserId":userID!, "ImageContent":imageBaseString] as [String : Any]
        
        ServiceSession.shared.callToPostDataToServerWithGivenURLString(urlString: profilePicURL, postBodyDictionary: postDic as NSDictionary, completionHandler: { (json) in
            let jsonDic = json as! NSDictionary
            if let status = jsonDic.object(forKey: "Status") as? Bool {

                // self.displayImageView.image = UIImage(data: self.compressedImageData as Data)

                let message = jsonDic.object(forKey: "Message")as? String
                if status == true {
                   if  let image = UIImage(data: self.compressedImageData as Data)
                   {
                        self.displayImageView.image = image
                        imageCache.setObject(image, forKey: self.profilePicURLString as NSString)
                       self.didFinishPickingImage?(image)
                       let dict = jsonDic.object(forKey: "Result") as? NSDictionary
                      // let profilePicPath = dict?.object(forKey: "ProfilePicPath") as? String
                     //  print(profilePicPath)
                       CurrentUservars.profilePicUrl = image
                    }
                    
                }
                else
                {
                    AlertManager.sharedInstance.showAlert(alertMessage: message ?? somethingWentWrong, title: "")
                    return
                }


            }
        })
        
    }


}
