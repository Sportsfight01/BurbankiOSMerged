//
//  UIImage + Extensions.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 08/04/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit
extension UIImage
{
  var highestQualityJPEGNSData: Data { return self.jpegData(compressionQuality: 1.0)! }
  var highQualityJPEGNSData: Data    { return jpegData(compressionQuality: 0.75)!}
  var mediumQualityJPEGNSData: Data  { return jpegData(compressionQuality: 0.5)! }
  var lowQualityJPEGNSData: Data     { return jpegData(compressionQuality: 0.25)!}
  var lowestQualityJPEGNSData: Data  { return jpegData(compressionQuality: 0.0)! }
}
extension UIImage {

    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func getSizeIn(_ type: DataUnits)-> String {

        guard let data = self.pngData() else {
            return ""
        }

        var size: Double = 0.0

        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }

        return String(format: "%.2f", size)
    }
  
}
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}
extension UIImage
{
    func convertImageToBase64String() -> String {
        return self.jpegData(compressionQuality: 1)?.base64EncodedString() ?? ""
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
}


// MARK: - Convert Image to PDF

func createPDFDataFromImage(image: UIImage) -> NSMutableData {
    let pdfData = NSMutableData()
    let imgView = UIImageView.init(image: image)
    let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
    UIGraphicsBeginPDFContextToData(pdfData, imageRect, nil)
    UIGraphicsBeginPDFPage()
    let context = UIGraphicsGetCurrentContext()
    imgView.layer.render(in: context!)
    UIGraphicsEndPDFContext()

    //try saving in doc dir to confirm:
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    let path = dir?.appendingPathComponent("file.pdf")

    do {
            try pdfData.write(to: path!, options: NSData.WritingOptions.atomic)
    } catch {
        print("error catched")
    }

    return pdfData
}


class RoundImage : UIImageView
{
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = max(bounds.height, bounds.width)/2
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
}
