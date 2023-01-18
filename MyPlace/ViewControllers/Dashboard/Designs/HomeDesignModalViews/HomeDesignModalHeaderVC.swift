//
//  HomeDesignModalHeaderVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

enum DesignAnswer: String {
    case must = "I must have this"
    case dontmind = "I don't mind"
    case donotwantthis = "I do not want this"
}

//enum MasterBedRoomAnswer: String {
//    case atFront = "At the front"
//    case atRear = "At the rear"
//    case dontmind = "I don't mind"
//}

class HomeDesignModalHeaderVC: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    var homeDesignFeature: HomeDesignFeature?
    
    var selectionUpdates: ((_ VC : HomeDesignModalHeaderVC) -> Void)?
    
    
    var selectionAlertMessage = "Please select"
    
    var isDo_not_want_this_ENABLED : Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = APPCOLORS_3.Body_BG
        contentView.backgroundColor = APPCOLORS_3.Body_BG
        print("++++++++",homeDesignFeature!.answerOptions[0].displayAnswer)
        
        if homeDesignFeature!.answerOptions.contains(where: { $0.displayAnswer == "I do not want this" })   {
        isDo_not_want_this_ENABLED = true
        }else{
            isDo_not_want_this_ENABLED = false
        }
    }
    
    
    
    //MARK: - Layout
    
    func reloadView () {
        
    }
    
    //MARK: - View Updates
    
    func clearSelections () {
        
        homeDesignFeature?.selectedAnswer = ""
        homeDesignFeature?.displayString = ""
    }
    
    
    //MARK: - View
    
    func addContentView (toView: UIView, with VC: UIViewController) {
        
        //        if let content = contentView {
        
        //            content.translatesAutoresizingMaskIntoConstraints = false
        //            toView.addSubview(content)
        //
        //            NSLayoutConstraint.activate([
        //                content.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
        //                content.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: 0),
        //                content.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
        //                content.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
        //            ])
        
        
        
        VC.addChild(self)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        toView.addSubview(self.view)
        
        
        NSLayoutConstraint.activate([
            self.view.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
            self.view.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
            self.view.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
            //            sortFilterView.view.bottomAnchor.constraint(equalTo: containerViewSortFilter!.layoutMarginsGuide.bottomAnchor, constant: 0)
//            self.view.bottomAnchor.constraint(equalTo: toView.layoutMarginsGuide.bottomAnchor, constant: 0)
            self.view.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: 0)
        ])
        
        self.view.backgroundColor = COLOR_CLEAR
        
        
        self.didMove(toParent: VC)
        
        
        //        }
        
    }
           
    
}
