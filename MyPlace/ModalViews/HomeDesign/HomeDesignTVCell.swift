//
//  HomeDesignTVCell.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 07/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import MapKit

class HomeDesignTVCell: UITableViewCell {

    @IBOutlet weak var imageHouse: UIImageView!

    @IBOutlet weak var lBName: UILabel!
    @IBOutlet weak var lBEstateName: UILabel!
    @IBOutlet weak var lBAddress: UILabel!

    @IBOutlet weak var lBDirections: UILabel!
    @IBOutlet weak var lBPlanMyDay: UILabel!

    
    @IBOutlet weak var btnDirections: UIButton!
    @IBOutlet weak var btnPlanMyDay: UIButton!

    
    
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var lBDisplayTitle: UILabel!
    
    @IBOutlet weak var lBDisplayHomeName1: UILabel!
    @IBOutlet weak var lBDisplayFacadeName1: UILabel!
    @IBOutlet weak var lBDisplayHomeName2: UILabel!
    @IBOutlet weak var lBDisplayFacadeName2: UILabel!

    @IBOutlet weak var lBTimings1: UILabel!
    @IBOutlet weak var lBTimings2: UILabel!
    @IBOutlet weak var lBTimings3: UILabel!

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        setAppearanceFor(view: lBName, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_LIGHT(size: FONT_14))
        
        setAppearanceFor(view: lBEstateName, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_LIGHT(size: FONT_12))
        setAppearanceFor(view: lBAddress, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_LIGHT(size: FONT_12))

        setAppearanceFor(view: lBDirections, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_6))
        setAppearanceFor(view: lBPlanMyDay, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_SUB_HEADING(size: FONT_6))

        
        setAppearanceFor(view: lBDisplayTitle, backgroundColor: COLOR_CLEAR, textColor: COLOR_ORANGE, textFont: FONT_LABEL_BODY(size: FONT_10))

        setAppearanceFor(view: lBDisplayHomeName1, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_10))
        setAppearanceFor(view: lBDisplayHomeName2, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY(size: FONT_10))
        
        setAppearanceFor(view: lBDisplayFacadeName1, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_8))
        setAppearanceFor(view: lBDisplayFacadeName2, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_8))

        
        setAppearanceFor(view: lBTimings1, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_8))
        setAppearanceFor(view: lBTimings2, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_8))
        setAppearanceFor(view: lBTimings3, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_8))
        
        
        let _ = setAttributetitleFor(view: lBPlanMyDay, title: "Plan MyDay", rangeStrings: ["My"], colors: [COLOR_BLACK], fonts: [FONT_LABEL_SUB_HEADING(size: FONT_6)], alignmentCenter: false)
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func handleDirectionsMyPlanButtons (_ sender: UIButton) {
        
        if sender == btnPlanMyDay {
            
        }else {
            
        }
    }
    
    

}



extension HomeDesignTVCell: MKMapViewDelegate {
    
    
    
}
