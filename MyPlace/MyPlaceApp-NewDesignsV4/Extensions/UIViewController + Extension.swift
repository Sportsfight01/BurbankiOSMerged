//
//  UIViewController + Extension.swift
//  BurbankApp
//
//  Created by naresh banavath on 29/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func setupNavigationBarButtons(shouldShowNotification : Bool = true)
    {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //Setting appearance
        self.setupAppearance()
        ///BackButton Setup
        self.addBackButton()
        ///NavigationLogo
        self.addLogoToNavigationBarItem()
       
        ///Adding ContactUs Btn
        if shouldShowNotification{
            self.addContactUsButton()
        }else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
    //MARK: - NavigationBtnSetup Functions
    func setupAppearance()
    {
        self.navigationController?.navigationBar.barTintColor = AppColors.myplaceGray
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = UIColor(red: 230/255, green: 231/255, blue: 232/255, alpha: 0.5)
        appearance.backgroundColor = AppColors.myplaceGray
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
    }
    func addBackButton()
    {
        //Adding BackButton to navigationBar
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        backButton.tintColor = .white
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        // self.navigationController?.navigationBar.back
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    func addLogoToNavigationBarItem() {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image =  UIImage(named: "Top Menu Icon_ButbankMyplace")
        imageView.tintColor = .white
        let contentView = UIView()
        self.navigationItem.titleView = contentView
        self.navigationItem.titleView?.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: self.view.frame.width * 0.5)//50% of screen width
        
        ])
    }
    func addContactUsButton()
    {
        // - Dot View
        let dotView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 7, height: 7)))
        dotView.cornerRadius = 4
        dotView.backgroundColor = APPCOLORS_3.Orange_BG
        dotView.isHidden = CurrentUser.notesUnReadCount > 0 ? false : true
        //notification button
        let contactUsBtn = UIButton(type: .custom)
        //  btn1.backgroundColor = UIColor.blue
        let image = UIImage(systemName: "ellipsis.message", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
        contactUsBtn.setImage(image ?? UIImage(named: "Top Menu Icons_Chat"), for: .normal)
        contactUsBtn.tintColor = .white
        contactUsBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        contactUsBtn.addSubview(dotView)
        contactUsBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        contactUsBtn.addTarget(self, action: #selector(contactUsbtnClicked), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: contactUsBtn)
        // - Constraints for DotView
        
        dotView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dotView.topAnchor.constraint(equalTo: contactUsBtn.topAnchor, constant: 3),
            dotView.trailingAnchor.constraint(equalTo: contactUsBtn.trailingAnchor, constant: 0),
            dotView.heightAnchor.constraint(equalToConstant: 8),
            dotView.widthAnchor.constraint(equalToConstant: 8)

        ])
  
    }
    
    //MARK: - Navigation Btn Action Methods
    @IBAction func backButtonClicked()
    {
        
       let isChanged = UserDefaults.standard.bool(forKey: "isChanged")
        if isChanged{
            print("changed Functions +=====++++=======")
            let alertController = UIAlertController(title: "", message: "Do you wish to save the changes to your notifications?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                UserDefaults.standard.set(false, forKey: "isChanged")
                NotificationCenter.default.post(name: NSNotification.Name("isChangedNotifications"), object: nil, userInfo: nil)

                self.dismiss(animated: true, completion: nil)
                return
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                UIAlertAction in
                UserDefaults.standard.set(false, forKey: "isChanged")
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            cancelAction.setValue( APPCOLORS_3.Black_BG, forKey: "titleTextColor")
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }else{
            
        }
        
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
    
    
    
    @objc func contactUsbtnClicked()
    {
        let vc = ContactUsVC.instace(sb: .supportAndHelp)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Utility Methods
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
}
//MARK: - ViewController Instance Creation
extension UIViewController
{
    #warning("must provide proper storyboard name to create viewcontroller instance")
    static func instace(sb : StoryBoard = .newDesignV4) -> Self{
        
        let instance = UIStoryboard(name: sb.rawValue, bundle: nil).instantiateViewController(withIdentifier: String(describing: self)) as! Self
        return instance
    }
    
    enum StoryBoard : String
    {
        case newDesignV4 = "NewDesignsV4"
        case supportAndHelp = "SupportAndHelp"
        case myPlaceLogin = "MyPlaceLogin"
    }
}

//MARK: - NavigationBar Extension
extension UINavigationBar {
    
    func shouldRemoveShadow(_ value: Bool) -> Void {
        if value {
            self.setValue(true, forKey: "hidesShadow")
        } else {
            self.setValue(false, forKey: "hidesShadow")
        }
    }
}

//MARK: - Leading Constraint of Navigation Title
extension UIViewController
{
    func getLeadingSpaceForNavigationTitleImage() -> Double
    {
        //just to align the header Title with navigationTitle
        let screenWidth = self.view.frame.width
        let navigationTitleImgWidth = screenWidth * 0.5
        let leadingConstant = (screenWidth / 2) - (navigationTitleImgWidth / 2) + 12
        debugPrint("screenWidth :- \(screenWidth), titlewidth :- \(navigationTitleImgWidth), leadinConstant :- \(leadingConstant)")
        return leadingConstant
    }
}
