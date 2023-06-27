//
//  UIAlertController + Extension.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 26/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
extension UIAlertController {
    func addImage(image : UIImage)
    {
        let maxSize = CGSize(width: 240, height: 244)
        let imgSize = image.size
        var ratio:CGFloat!
        if (imgSize.width > imgSize.height){
            ratio = maxSize.width / imgSize.width
        }else {
            ratio = maxSize.height / imgSize.height
        }
        let scaleSize = CGSize(width: imgSize.width*ratio, height: imgSize.height*ratio)
        var resizedImage = image.imageWithSize(scaleSize)

        if (imgSize.height > imgSize.width) {
            let left = (maxSize.width - resizedImage.size.width) / 2
            resizedImage = resizedImage.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: -left, bottom: 0, right: 0))
        }

        let imgAction = UIAlertAction(title: "", style: .default, handler: nil)
        imgAction.isEnabled = false
        imgAction.setValue(resizedImage.withRenderingMode(.alwaysOriginal), forKey: "image")

        self.addAction(imgAction)
    }
}
