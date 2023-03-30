//
//  UIViewController + Extension.swift
//  BurbankApp
//
//  Created by naresh banavath on 29/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupNavigationBar()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.barTintColor = AppColors.appGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor.white
    }
    func setupNavigationBarButtons(title : String = "" ,backButton : Bool = true, notificationIcon : Bool = true)
    {
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        
        //Setting appearance
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.shadowColor = UIColor(red: 230/255, green: 231/255, blue: 232/255, alpha: 0.5)
            appearance.backgroundColor = AppColors.darkGray
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
            self.navigationController?.navigationBar.compactAppearance = appearance
        } else {
            // Fallback on earlier versions
            self.navigationController?.navigationBar.barTintColor = AppColors.appGray
        }
        
        //
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.addLogoToNavigationBarItem()
        //MARK: - Back Button
//        let backBtn = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonPressed))
//        backBtn.tintColor = .white
//        navigationItem.backBarButtonItem = backBtn
        
        
        let btn1 = UIButton(type: .custom)
        //  btn1.backgroundColor = UIColor.blue
        if #available(iOS 13.0, *) {
            btn1.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        } else {
            // Fallback on earlier versions
            btn1.setImage(UIImage(named: "Ico-Back"), for: .normal)
        }

        btn1.tintColor = .white
        btn1.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
       // btn1.backgroundColor = .red
        btn1.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        btn1.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        // self.navigationController?.navigationBar.back
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn1)
        
        //notification button
        let btn2 = UIButton(type: .custom)
        //  btn1.backgroundColor = UIColor.blue
        btn2.setImage(UIImage(named: "icon_Notification"), for: .normal)
        btn2.tintColor = .white
        btn2.frame = CGRect(x: 0, y: 0, width: 25, height: 10)
        btn2.imageEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 8)
        //  btn2.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        // self.navigationController?.navigationBar.back
        #warning("currently not receiving any data in contactus module so disabling this icon for now can be enabled later in future")
//        if notificationIcon{
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btn2)
//        }
        //to remove navigation separation line
        
    }
    func addLogoToNavigationBarItem() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.image =  UIImage(named: "Top Menu Icon_ButbankMyplace")
        imageView.tintColor = .white
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    @objc func backButtonPressed()
    {
        dismiss(animated: true, completion: nil)
        guard let navController = self.navigationController else {return}
        if navController.viewControllers.count == 1
        {
            //go to dashBoard
            //          let rootVc = UIStoryboard(name : "NewDesignsV4" , bundle : nil).instantiateInitialViewController()
            
            guard let vc = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateInitialViewController()else{return}
            self.view.window?.rootViewController = vc
            self.view.window?.becomeKey()
            self.view.window?.makeKeyAndVisible()
        }
        else{
            navController.popViewController(animated: true)
        }
        
    }
    
    func addGradientLayer(colors : [CGColor]? = [AppColors.appGray.cgColor , APPCOLORS_3.HeaderFooter_white_BG.cgColor])
    {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0,1]
        gradientLayer.colors = colors
        gradientLayer.frame = view.bounds
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    func dollarCurrencyFormatter(value : Double) -> String?
    {
        let price = value
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_AU")
        let formattedValue : String = formatter.string(from: NSNumber(floatLiteral: price))!
        return formattedValue
    }
    func dateFormatter(dateStr : String , currentFormate : String , requiredFormate : String) -> String?
    {
        //        let dateFormatter = DateFormatter()
        ////        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        //        dateFormatter.dateFormat = currentFormate
        //        let currentDate = dateFormatter.date(from: dateStr)
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFormate
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = requiredFormate
        
        if let date = dateFormatterGet.date(from: dateStr) {
            return dateFormatterPrint.string(from: date)
        } else {
            return nil
        }
    }
    
    
    //MARK: - Alerts
    
    func showAlert(message : String? , okCompletion : ((String)->())? = nil)
    {
        let alertController = UIAlertController(title: "MyPlace", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { action in
            okCompletion?("OK")
        })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func downloadImage()
    {
        let urlReq = URLRequest(url: URL(string: "")!)
        URLSession.shared.downloadTask(with: urlReq) { url, res, err in
            
        }
    }
    
}
extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if (image != nil)
        {
            return image!
        }
        return UIImage()
    }
    
    func appalyShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 10
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    
}
extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}
