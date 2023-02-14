//
//  RecentSearchPopUp.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 13/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class RecentSearchPopUp: UIViewController {

    @IBOutlet weak var recentSearchHeading: UILabel!
    
    @IBOutlet weak var recentSearch: UILabel!

    
    @IBOutlet weak var btnClose: UIButton!

    @IBOutlet weak var btnShow: UIButton!
    @IBOutlet weak var btnStart: UIButton!

    
    var recentSearchFrom: String? {
        didSet {
            
            let str = "RECENT SEARCH" + "\n" + "(\(recentSearchFrom!))"
                        
            _ = setAttributetitleFor(view: recentSearchHeading, title: str, rangeStrings: ["RECENT SEARCH", "(\(recentSearchFrom!))"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.GreyTextFont], fonts: [FONT_LABEL_SUB_HEADING(size: FONT_18), FONT_LABEL_LIGHT (size: FONT_14)], alignmentCenter: true)
        }
    }
    
    
    var showAction: (() -> Void)?
    var startNewAction: (() -> Void)?
    
    
    var filter: SortFilter? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setupUI()
        
        
        let tap = UITapGestureRecognizer (target: self, action: #selector(handleGestureRecognizer(_:)))
        view.addGestureRecognizer(tap)

    }
    
    
    func setupUI () {
        
        setAppearanceFor(view: recentSearchHeading, backgroundColor: nil, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING(size: FONT_18))
        
        setAppearanceFor(view: recentSearch, backgroundColor: nil, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_BODY (size: FONT_14))

        setAppearanceFor(view: btnStart, backgroundColor: APPCOLORS_3.Black_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_16))

        setAppearanceFor(view: btnShow, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_BUTTON_SUB_HEADING (size: FONT_16))
        
    }
    

    @IBAction func handleButtonActions (_ sender: UIButton) {

        if sender == btnShow {
            if let action = showAction {
                action ()
            }
        }else {
            if let action = startNewAction {
                action ()
            }
        }
        
    }
    
    
    @objc func handleGestureRecognizer (_ recognizer: UITapGestureRecognizer) {
                
        if recentSearchHeading.superview!.frame.contains(recognizer.location(ofTouch: 0, in: self.view)) {
            
        }else {
            if let action = startNewAction {
                action ()
            }
        }
        
    }
    
}
