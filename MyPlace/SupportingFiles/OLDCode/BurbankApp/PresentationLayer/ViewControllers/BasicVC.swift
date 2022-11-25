//
//  BasicVC.swift
//  BurbankApp
//
//  Created by dmss on 10/05/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit


class BasicVC: BurbankAppVC
{
    var logoImageView: UIImageView! = {
        let imgVw = UIImageView()
        imgVw.translatesAutoresizingMaskIntoConstraints = false
        imgVw.image = #imageLiteral(resourceName: "Icon-logo")
        
        return imgVw
    }()
    
    var backButton: UIButton! = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "Ico-Back"), for: .normal)
        button.addTarget(self, action: #selector(handelBackButtonTapped), for: .touchDown)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 11.0, *) {
            setUpLogoImageViewForiPhoneX()
        } else {
            setUpLogoImageView()
        }
        
        setUpBackButton()
        
    }
    
    @available(iOS 11.0, *)
    func setUpLogoImageViewForiPhoneX()
    {
        view.addSubview(logoImageView)
        let centerYConstant = SCREEN_HEIGHT * 0.5 * 0.75
        logoImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -centerYConstant).isActive = true
        logoImageView.safeAreaLayoutGuide.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.075).isActive = true
        logoImageView.safeAreaLayoutGuide.widthAnchor.constraint(equalTo: logoImageView.safeAreaLayoutGuide.heightAnchor, multiplier: 4).isActive = true
        logoImageView.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: 0).isActive = true
    }
    func setUpLogoImageView()
    {
        view.addSubview(logoImageView)
        let centerYConstant = SCREEN_HEIGHT * 0.5 * 0.86 //* 0.5 * 0.14
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -centerYConstant).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.075).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, multiplier: 4).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
    }
    func setUpBackButton()
    {
        view.addSubview(backButton)
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        backButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor, constant: 0).isActive = true
        backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor, multiplier: 1).isActive = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func handelBackButtonTapped(sender: AnyObject?)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
