//
//  UIImageView + Extensions.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 22/11/22.
//  Copyright © 2022 DMSS. All rights reserved.
//

import UIKit
extension UIImageView {
//    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleToFill) {
//        contentMode = mode
//        let urlRequest = URLRequest(url: url)
//        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
//            guard let dataa = data else {return}
//            DispatchQueue.main.async {
//                self.image = UIImage(data: dataa)
//            }
//        }.resume()
//
//       // self.image = nil
//    }
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
           contentMode = mode
           URLSession.shared.dataTask(with: url) { data, response, error in
               guard
                   let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                   let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                   let data = data, error == nil,
                   let image = UIImage(data: data)
                   else { return }
               DispatchQueue.main.async() { [weak self] in
                   self?.image = image
                   CurrentUser.profilePicUrl = image
               }
           }.resume()
       }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleToFill) {
        guard let url = URL(string: link) else {  self.image = UIImage(named: "BurbankLogo_White")?.withRenderingMode(.alwaysTemplate).withTintColor(APPCOLORS_3.GreyTextFont)  ; return }
        downloaded(from: url, contentMode: mode)
    }
}
