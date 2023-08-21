//
//  HomeCareBaseProfileVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 03/05/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit
import SideMenu

class HomeCareBaseProfileVC: UIViewController {

    var profileBaseView : HomeCareHeaderView!
    var menu : SideMenuNavigationController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       self.setStatusBar(AppColors.AppGray)
        addProfileHeaderView()
        sideMenuSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.profileBaseView.dotView.isHidden = CurrentUser.notesUnReadCount > 0 ? false : true
        getNotes()
    }
    
    //MARK: - Helper Methods
    func getNotes()
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
                    self?.profileBaseView.dotView.isHidden = CurrentUser.notesUnReadCount > 0 ? false : true
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
        
        self.profileBaseView = HomeCareHeaderView(frame: .zero)
        self.view.addSubview(profileBaseView)
        profileBaseView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileBaseView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileBaseView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileBaseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            profileBaseView.heightAnchor.constraint(equalToConstant: 200)
        
        ])
        
        profileBaseView.menuAndBackBtn.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        profileBaseView.contactUsBtn.addTarget(self, action: #selector(contactUsButtonTapped), for: .touchUpInside)
        profileBaseView.burbankLogoBTN.addTarget(self, action: #selector(didTappedOnBurbanklogo), for: .touchUpInside)

    }
    func setStatusBar(_ color : UIColor = .gray)
    {
        let statusBar = UIView(frame: kWindow.windowScene?.statusBarManager?.statusBarFrame ?? .zero)
        statusBar.backgroundColor = color
        self.view.addSubview(statusBar)
       
    }
    func setupProfile()
    {
       
        profileBaseView.profileView.contentMode = .scaleToFill
        profileBaseView.profileView.clipsToBounds = true
        profileBaseView.profileView.layer.cornerRadius = profileBaseView.profileView.bounds.width/2
        if let imgURlStr = CurrentUser.profilePicUrl
        {
            profileBaseView.profileView.image = imgURlStr
        }
        if appDelegate.notificationCount == 0{
            profileBaseView.notificationCountLBL.isHidden = true
        }else{
            profileBaseView.notificationCountLBL.text = "\(appDelegate.notificationCount)"
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileClick(recognizer:)))
        profileBaseView.profileView.superview?.addGestureRecognizer(tap)
       

//        if profileBaseView.backgroundColor == .white{
//            profileBaseView.titleLBL.textColor = .black
//            profileBaseView.descriptionLBL.textColor = .black
//        }else{
//            profileBaseView.titleLBL.textColor = .white
//            profileBaseView.descriptionLBL.textColor = .white
//        }
        
        
    }
    
    func sideMenuSetup()
    {
        let sideMenuVc = UIStoryboard(name: "NewDesignsV4", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        //sideMenuVc.isHomecareSideMenu = true
        menu = SideMenuNavigationController(rootViewController: sideMenuVc)
        menu.leftSide = true
        sideMenuVc.isMenuOpenedFromHomeCare = true
        menu.menuWidth = 0.8 * UIScreen.main.bounds.width
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.onTopShadowColor = .darkGray
        menu.presentationStyle.onTopShadowOffset = CGSize(width: 1.0, height: 1.0)
        menu.presentationStyle.onTopShadowOpacity = 1.0
        menu.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.leftMenuNavigationController?.dismissOnPush = false
    }
    
    @objc func didTappedOnBurbanklogo(){
        self.navigationController?.parent?.navigationController?.viewControllers.forEach({ vc in
            if vc.isKind(of: HomeCareDashBoardVC.self)
            {
                vc.navigationController?.popToViewController(vc, animated: true)
            }
        })
    }
    
    @objc func contactUsButtonTapped(){
        let vc = ContactUsVC.instace(sb : .supportAndHelp)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func menuButtonTapped(sender : UIButton)
    {
//        if profileBaseView.menuAndBackBtn.currentImage == (UIImage(systemName:"arrow.left", withConfiguration: UIImage.SymbolConfiguration(scale: .large))){
//            self.navigationController?.parent?.navigationController?.viewControllers.forEach({ vc in
//                if vc.isKind(of: HomeCareDashBoardScreenVC.self)
//                {
//                    vc.navigationController?.popToViewController(vc, animated: true)
//                }
//            })
//        }
           
        debugPrint("leftBarButtonTapped")
        present(menu, animated: true)
    }
    @objc func handleProfileClick (recognizer: UIGestureRecognizer) {
       

    }

}
extension UIApplication {
    class var statusBarBackgroundColor: UIColor? {
        get {
            return (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor
        } set {
            (shared.value(forKey: "statusBar") as? UIView)?.backgroundColor = newValue
        }
    }
}
