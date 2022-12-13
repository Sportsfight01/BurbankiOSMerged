//
//  StateSelectionVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 05/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit


protocol StateSelectionVCDelegate: NSObject {
    
    func handleStateSelectionDelegate (close: Bool, stateBtn: Bool, state: State)
    
}


let cellHeight: CGFloat = SCREEN_WIDTH/9.86 //SCREEN_HEIGHT/17.55


class StateSelectionVC: UIViewController {
    
    
    @IBOutlet weak var viewSelection: UIView!
    
    @IBOutlet weak var lBSelection: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var tableSelection: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    
    
    weak var delegateState: StateSelectionVCDelegate?
    
    
    
    var arrStates: [State]? {
        didSet {
            
        }
    }
    
    var statePrevious: State?
    var stateSelected: State = State.init()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setAppearanceFor(view: lBSelection, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        
        
        viewSelection.layer.cornerRadius = radius_5
        
        CodeManager.sharedInstance.sendScreenName(burbank_selectState_screen_loading)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        layoutTable ()
    }
    
    
    func layoutTable () {
        
        self.tableSelection.reloadData()
        self.tableSelection.layoutIfNeeded()
        
        
        self.tableSelection.isScrollEnabled = true
        
        tableHeight.constant = self.tableSelection.contentSize.height
        
        if let states = arrStates {
            tableHeight.constant = cellHeight*CGFloat((states.count)) + 10.0*CGFloat((states.count))
        }else {
            tableHeight.constant = 0
        }
        
        self.tableSelection.isScrollEnabled = false
    }
    
    
    
    @IBAction func handleCloseAction(_ sender: UIButton) {
        
        //        if state == State_MyPlace.none, stateSelected == State_MyPlace.none {
        
        CodeManager.sharedInstance.sendScreenName (burbank_selectState_close_button_touch)
        
        
        if let previous = statePrevious {
            print(log: previous.stateName)
        }
        
        if stateSelected.stateId == String.zero() {
            
            showToast("Please select state", self)
            
            return
        }
        
        self.delegateState?.handleStateSelectionDelegate(close: true, stateBtn: false, state: stateSelected)
    }
    
    
    
}


extension StateSelectionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrStates?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! StateSelection
        
        let state = arrStates![indexPath.row]
        
        cell.lBTitle.text = state.stateName.uppercased()
        
        if stateSelected.stateId == state.stateId {
            
            cell.viewS.backgroundColor = COLOR_ORANGE
            cell.lBTitle.textColor = COLOR_WHITE
        }else {
            cell.viewS.backgroundColor = COLOR_CLEAR
            cell.lBTitle.textColor = COLOR_DARK_GRAY
            if #available(iOS 13.0, *) {
                cell.viewS.cardView(cornerRadius: radius_5, shadowOpacity: 0.3, shadowColor: UIColor.systemGray3.cgColor)
            } else {
                // Fallback on earlier versions
                cell.viewS.cardView(cornerRadius: radius_5, shadowOpacity: 0.3)
            }
        }
        
        //        cell.lBTitle.frame = CGRect.init(x: 2, y: 2, width: cell.frame.size.width - 4, height: cell.frame.size.height - 4 - 4)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        stateSelected = arrStates![indexPath.row]
     
        tableView.reloadData()
        
        self.delegateState?.handleStateSelectionDelegate(close: false, stateBtn: true, state: stateSelected)
      let event = "BB_selectedState_\(stateSelected.stateName.replacingOccurrences(of: " ", with: "_"))"
        CodeManager.sharedInstance.sendScreenName(event)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight + 10
    }
    
    
}


class StateSelection: UITableViewCell {
    
    @IBOutlet weak var viewS: UIView!
    @IBOutlet weak var lBTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        
//        viewS.layer.cornerRadius = radius_3
      //  viewS.clipsToBounds = true
        viewS.cardView(cornerRadius: radius_5)
       // setBorder(view: viewS, color: COLOR_ORANGE, width: 1.0)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
