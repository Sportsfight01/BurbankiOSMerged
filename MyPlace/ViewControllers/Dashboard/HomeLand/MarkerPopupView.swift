//
//  MarkerPopupView.swift
//  MyPlace
//
//  Created by Mohan Kumar on 16/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class MarkerPopupView: UIView {
    
    var contentView: UIView?
    
    
    @IBOutlet weak var lBPrice: UILabel!
    @IBOutlet weak var lBName: UILabel!
    @IBOutlet weak var lBAddress: UILabel!
    @IBOutlet weak var lBBedroom: UILabel!
    @IBOutlet weak var lBBathroom: UILabel!
    @IBOutlet weak var lBParking: UILabel!
    
    @IBOutlet weak var btnView: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadViewFromNib()
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        loadViewFromNib()
        setUI()
    }
    
    
    func loadViewFromNib() {
        let bundle = Bundle.main
        let nib =  bundle.loadNibNamed("MarkerPopupView", owner: self, options: nil)![0] as! UIView
        nib.frame = bounds
        nib.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addSubview(nib)
    }
    
    
    func setUI() {
        
        setAppearanceFor(view: lBPrice, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
        setAppearanceFor(view: lBName, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_14))
        setAppearanceFor(view: lBAddress, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        setAppearanceFor(view: lBBedroom, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        setAppearanceFor(view: lBBathroom, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        setAppearanceFor(view: lBParking, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        
        setAppearanceFor(view: btnView, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        btnView.layer.cornerRadius = radius_5
        
    }
}


class MarkerInfoVC: UIViewController {
    
    
    
    @IBOutlet weak var lBPrice: UILabel!
    @IBOutlet weak var lBName: UILabel!
    @IBOutlet weak var lBAddress: UILabel!
    @IBOutlet weak var lBBedroom: UILabel!
    @IBOutlet weak var lBBathroom: UILabel!
    @IBOutlet weak var lBParking: UILabel!
    
    @IBOutlet weak var btnView: UIButton!
    
    
    var dismissAction: (() -> Void)?
    var detailViewAction: ((_ package: HomeLandPackage?) -> Void)?
    
    
    var homeLandPackage: HomeLandPackage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        let tap = UITapGestureRecognizer (target: self, action: #selector(handleGestureRecognizer(_:)))
        view.addGestureRecognizer(tap)
        
        btnView.addTarget(self, action: #selector(handleViewButton(_:)), for: .touchUpInside)
    }
    
    
    
    func setUI() {
        
        setAppearanceFor(view: lBPrice, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_16))
        setAppearanceFor(view: lBName, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_14))
        setAppearanceFor(view: lBAddress, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        setAppearanceFor(view: lBBedroom, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        setAppearanceFor(view: lBBathroom, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        setAppearanceFor(view: lBParking, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        
        setAppearanceFor(view: btnView, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_SUB_HEADING(size: FONT_15))
        btnView.layer.cornerRadius = radius_5
        
        
    }
    
    
    
    func fillDetails (with package: HomeLandPackage) {
        
        homeLandPackage = package
        
        //self.lBPrice.text = "$" + (package.price ?? "")
        self.lBPrice.text = String.currencyFormate(Int32(package.price ?? "")!)
        
        self.lBName.text = package.houseName ?? ""
        self.lBAddress.text = package.address ?? ""
        
        self.lBBedroom.text = package.bedRooms ?? ""
        self.lBBathroom.text = package.bathRooms ?? ""
        self.lBParking.text = package.carSpace ?? ""
        
    }
    
    
    @IBAction func handleViewButton (_ sender: UIButton) {
        
        if let action = detailViewAction {
            action (self.homeLandPackage)
        }
    }
    
    
    @objc func handleGestureRecognizer (_ recognizer: UITapGestureRecognizer) {
        
        if btnView.superview!.frame.contains(recognizer.location(ofTouch: 0, in: self.view)) {
            
        }else {
            if let action = dismissAction {
                action ()
            }
        }
        
    }
        
}
