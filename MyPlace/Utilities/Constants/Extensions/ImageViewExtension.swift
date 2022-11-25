//
//  ImageExtension.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 04/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView
{
    /**
     To load the image
     
     #1. Check image is avaialble in cache or not.
     A. If not Download the image from URL and save in cache.
     B. If the image is avaible in cache then direct pass the image to imageview.
     
     
     - parameters:
      - urlString: The urlString in the Image URL, cannot be empty
     
 */
    func loadImageUsingCacheUrlString(urlString: String)
    {
        self.image = UIImage(named: "defaultGallery.png")
        
        let urlStr = urlString.replacingOccurrences(of: " ", with: "%20")
        
        //Check cache for image first
        if let cachedImage = imageCache.object(forKey: urlStr as NSString)
        {
            self.image = cachedImage
            return
        }
        let url = NSURL(string: urlStr)
        if url != nil
        {
            URLSession.shared.dataTask(with: url! as URL){
                data,response,error  in
                
                if error != nil
                {
//                    #if DEDEBUG
//                    print("fail to download Image from FB with error: \(error?.localizedDescription)")
//                    #endif
                    return
                }
                DispatchQueue.main.async {
                    
                    if let downloadedImage = UIImage(data: data!)
                    {
                        imageCache.setObject(downloadedImage, forKey: urlStr as NSString)
                        self.image = downloadedImage
                    }
                   }
                }.resume()
        }
    }
    
//    
//    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                self.image = image
//            }
//            }.resume()
//    }
//    
//    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
//        guard let url = URL(string: link) else { return }
//        downloaded(from: url, contentMode: mode)
//    }
    
}



extension UIImageView {
    
    func showActivityIndicator () {
        
        let activity = UIActivityIndicatorView(frame: CGRect(x: (self.frame.size.width/2)-10, y: (self.frame.size.height/2)-10, width: 20, height: 20))
        activity.center = self.center
        activity.tag = 1001
        activity.style = .gray
        activity.hidesWhenStopped = true
        self.addSubview(activity)
        
        activity.startAnimating()

    }
    
    func hideActivityIndicator () {
        if let activity = self.viewWithTag(1001) as? UIActivityIndicatorView {
            activity.stopAnimating()
        }
    }
    
}



func downloadImage (from url: URL, success: @escaping ((_ image: UIImage?, _ error: Error?, _ succes: Bool) -> Void)) {
    
//        do {
//            let imageData = try? Data (contentsOf: url)
//            if let data = imageData {
//                if let image = UIImage (data: data) {
//                    success (image, nil, true)
//                }
//            }
//        }

    
    let request = URLRequest (url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)

    URLSession.shared.dataTask(with: request) { (data, response, error) in

        guard let dataRe = data, error == nil, (response as? HTTPURLResponse)?.statusCode == 200 else {
            success(nil, error, false)
            return
        }

        guard let mimeType = response?.mimeType, mimeType.hasPrefix("image") else {
            success(nil, error, false)
            return
        }

        guard let image = UIImage (data: dataRe) else {
            success(nil, error, false)
            return
        }

        success (image, nil, true)

    }.resume()
    
}

extension UIImage {
    var base64: String? {
        self.jpegData(compressionQuality: 1)?.base64EncodedString()
    }
}
