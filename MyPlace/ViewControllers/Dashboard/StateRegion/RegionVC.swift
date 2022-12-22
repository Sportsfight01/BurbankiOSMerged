//
//  RegionVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit



protocol RegionVCDelegate: NSObject {
    
    func handleRegionDelegate (close: Bool, regionBtn: Bool, region: RegionMyPlace)
    
}



class RegionVC: UIViewController {
    
    var arrRegions: [RegionMyPlace]?
    
    
    var selectedRegion: RegionMyPlace = RegionMyPlace.init()
    var previousRegion: RegionMyPlace?
    
    
    weak var delegate: RegionVCDelegate?
    
    
    @IBOutlet weak var regionView : UIView!
    
    @IBOutlet weak var region_lBregion: UILabel!
    
    
    @IBOutlet weak var regionsTable: UITableView!
    @IBOutlet weak var regionTableHeight: NSLayoutConstraint!
    
    
    
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pageUISetUp()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutTable ()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        layoutTable ()
    }
    
    
    func layoutTable () {
        
        self.regionsTable.reloadData()
        self.regionsTable.layoutIfNeeded()
        
        
        self.regionsTable.isScrollEnabled = true
        
        regionTableHeight.constant = self.regionsTable.contentSize.height
        
        if let regions = arrRegions {
            regionTableHeight.constant = cellHeight*CGFloat((regions.count)) + 10.0*CGFloat((regions.count))
            
            if (regionsTable.frame.origin.y + regionTableHeight.constant + 20) > (SCREEN_HEIGHT - 80) {
                
                regionTableHeight.constant = (SCREEN_HEIGHT - 80 - (regionsTable.frame.origin.y + 20))
                
            }else {
                self.regionsTable.isScrollEnabled = false
            }        
        }else {
            regionTableHeight.constant = 0
        }
        
        
    }
    
    
    
    //MARK: - View
    
    func pageUISetUp () {
        
        
        let str = "WHAT REGION ARE YOU\nLOOKING FOR YOUR NEW HOME?"
        region_lBregion.text = str
        
        setAppearanceFor(view: region_lBregion, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_LIGHT(size: FONT_18))
        
        
        regionView.layer.cornerRadius = radius_5
    }
    
    
    //MARK: - ButtonActions
    
    
    @IBAction func handleCloseButton (_ sender: UIButton) {
        
        if selectedRegion == .none {
            AlertManager.sharedInstance.showAlert(alertMessage : "Please select region")
            return
        }
        delegate?.handleRegionDelegate(close: true, regionBtn: false, region: selectedRegion)
    }
    
}


extension RegionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRegions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionTableViewCell", for: indexPath) as! RegionTableViewCell
        
        let region = arrRegions![indexPath.row]
        
        cell.titleLabel.text = region.regionName
        
        cell.selectedRegion = selectedRegion.regionId == region.regionId
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRegion = arrRegions![indexPath.row]
        
        tableView.reloadData()
        
        delegate?.handleRegionDelegate(close: false, regionBtn: true, region: selectedRegion)
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 10
    }
    
    
}



class RegionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var selectedRegion: Bool = false
    {
        didSet {
            if selectedRegion == true {
                titleLabel.textColor = COLOR_WHITE
                titleLabel.backgroundColor = COLOR_ORANGE
            }else {
                titleLabel.textColor = COLOR_BLACK
                titleLabel.backgroundColor = COLOR_WHITE
                if #available(iOS 13.0, *) {
                    titleLabel.cardView(cornerRadius: radius_10, shadowOpacity: 0.5, shadowColor: UIColor.systemGray2.cgColor)
                } else {
                    // Fallback on earlier versions
                    titleLabel.cardView(cornerRadius: radius_10, shadowOpacity: 0.3)
                }

            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_WHITE, textColor: COLOR_BLACK, textFont: FONT_LABEL_BODY (size: FONT_14))
////
        titleLabel.layer.cornerRadius = radius_5
//
//        setBorder(view: titleLabel, color: COLOR_ORANGE, width: 1.0)
//
//        titleLabel.clipsToBounds = true
      
          // titleLabel.cardView(cornerRadius: radius_5)
     
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
