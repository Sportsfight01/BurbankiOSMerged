//
//  MultipleJobNumberVC.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 18/04/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class MultipleJobNumberVC: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleOfTable: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    var previousJobNum : String?
    var tableDataSource : [String] = []
    var selectionClosure : ((String) -> ())?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        setupUI()
        self.view.backgroundColor = .black.withAlphaComponent(0.2)
        btnClose.addTarget(self, action: #selector(closeBtnAction), for: .touchUpInside)
        
    }
    func setupUI()
    {
        setAppearanceFor(view: titleOfTable, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))
        
        containerView.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG
        containerView.layer.cornerRadius = radius_5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleOfTable.text = "Please Select JobNumber"
        self.previousJobNum = UserDefaults.standard.value(forKey: "selectedJobNumber") as? String
        tableView.reloadData()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableHeight.constant = tableView.contentSize.height
    }
    
    
    @objc func closeBtnAction(_ sender : UIButton)
    {
        self.dismiss(animated: true)
    }
    
    
}
//MARK: -
extension MultipleJobNumberVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! MultipleJobNumbersCell
        cell.lBTitle.text = tableDataSource[indexPath.row].uppercased()
        cell.containerView.cardView(cornerRadius: radius_5,shadowOpacity: 0.3, shadowColor: UIColor.gray.cgColor)
        if previousJobNum == tableDataSource[indexPath.row] {

            cell.containerView.backgroundColor = APPCOLORS_3.Orange_BG
            cell.lBTitle.textColor = APPCOLORS_3.HeaderFooter_white_BG
        }else {
            cell.containerView.backgroundColor = COLOR_CLEAR
            cell.lBTitle.textColor = APPCOLORS_3.GreyTextFont
            if #available(iOS 13.0, *) {
                cell.containerView.cardView(cornerRadius: radius_5,shadowOpacity: 0.3, shadowColor: UIColor.gray.cgColor)
            } else {
                // Fallback on earlier versions
                cell.containerView.cardView(cornerRadius: radius_5, shadowOpacity: 0.3)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("selected Job Number :- \(tableDataSource[indexPath.row])")
        tableView.deselectRow(at: indexPath, animated: true)
        selectionClosure?(tableDataSource[indexPath.row])
        self.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: tableView.frame.width, height: 70)))
        footerLabel.numberOfLines = 0
        footerLabel.font = ProximaNovaRegular(size: 14.0)
        footerLabel.textColor = APPCOLORS_3.GreyTextFont
        footerLabel.textAlignment = .center
        footerLabel.text = "* Access other job numbers from menu option \"MyJobNumber\""
        
        return footerLabel
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 70
    }
    
}



class MultipleJobNumbersCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lBTitle: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setAppearanceFor(view: lBTitle, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
