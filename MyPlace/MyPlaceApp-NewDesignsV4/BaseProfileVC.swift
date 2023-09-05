//
//  BaseProfileVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 24/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import SideMenu

class BaseProfileVC: UIViewController {

    var profileView : ProfileHeaderView!
    var menu : SideMenuNavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()
        addProfileHeaderView()
        sideMenuSetup()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileView.profilePicImgView.superview?.addGestureRecognizer(tap)
        profileView.contactUsBtn.addTarget(self, action: #selector(contactUsBtnTapped), for: .touchUpInside)
        //getNotes()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfile()
        profileView.backgroundColor = .clear
        profileView.contentView.backgroundColor = .clear
       // setupNavigationItems()
       // self.view.backgroundColor = APPCOLORS_3.GreyTextFont
        self.profileView.dotView.isHidden = CurrentUser.notesUnReadCount > 0 ? false : true
        getNotes()
    }
    
 
    //MARK: - Helper Methods
    private func getNotes()
    {
        APIManager.shared.getNotes {[weak self] result in
            guard let self else { return }
            switch result{
            case .success(let notes):
                let mainNotes = notes.filter({$0.replyTo == nil})
                let maped = mainNotes.map { note in
                    UserDefaults.standard.value(forKey: "\(CurrentUser.jobNumber ?? "")_\(note.noteId ?? 0)_isRead") as? Bool
                }
                CurrentUser.notesUnReadCount = maped.filter({$0 == nil}).count
                DispatchQueue.main.async {[weak self] in
                    self?.profileView.dotView.isHidden = CurrentUser.notesUnReadCount > 0 ? false : true
                }
            case .failure(let err):
                debugPrint(err.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(message: err.description)
                    return}
                }
            }
        
    }
    func addProfileHeaderView()
    {
        self.profileView = ProfileHeaderView(frame: .zero)
        self.view.addSubview(profileView)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileView.heightAnchor.constraint(equalToConstant: 200)
        
        ])
        
        profileView.menubtn.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
    }
    
    func sideMenuSetup()
    {
        let sideMenuVc = MenuViewController.instace(sb: .newDesignV4)
        menu = SideMenuNavigationController(rootViewController: sideMenuVc)
        sideMenuVc.isMenuOpenedFromHomeCare = false
        menu.leftSide = true
        menu.menuWidth = 0.8 * UIScreen.main.bounds.width
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.onTopShadowColor = .darkGray
        menu.presentationStyle.onTopShadowOffset = CGSize(width: 1.0, height: 1.0)
        menu.presentationStyle.onTopShadowOpacity = 1.0
        menu.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.leftMenuNavigationController?.dismissOnPush = false
        
        
    }

    
    func setupProfile()
    {
        profileView.profilePicImgView.contentMode = .scaleToFill
        profileView.profilePicImgView.clipsToBounds = true
        profileView.profilePicImgView.layer.cornerRadius = profileView.profilePicImgView.bounds.width/2
        if let imgURlStr = CurrentUser.profilePicUrl
        {
            profileView.profilePicImgView.image = imgURlStr
        }
        if appDelegate.notificationCount == 0{
            profileView.notificationCountLb.isHidden = true
        }else{
            profileView.notificationCountLb.text = "\(appDelegate.notificationCount)"
        }
     
        
    }
    
    @objc func menuButtonTapped()
    {
        debugPrint("leftBarButtonTapped")
        present(menu, animated: true)
    }
    @objc func contactUsBtnTapped()
    {
        debugPrint("contactUsBtnTapped")
        let vc = ContactUsVC.instace(sb: .supportAndHelp)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
//        let vc = UIStoryboard(name: StoryboardNames.newDesing, bundle: nil).instantiateViewController(withIdentifier: "MenuVC") as! MenuVC
        let vc = NotificationsVC.instace(sb: .newDesignV4)
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
}
