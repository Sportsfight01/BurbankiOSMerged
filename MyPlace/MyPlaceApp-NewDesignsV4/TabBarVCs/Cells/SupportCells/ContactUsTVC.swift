//
//  ContactUsTVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 17/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class ContactUsTVC: UITableViewCell {

    @IBOutlet weak var noteDateLb: UILabel!
    @IBOutlet weak var bodyLb: UILabel!
    @IBOutlet weak var subjectLb: UILabel!
    @IBOutlet weak var authorNameLb: UILabel!
    
    @IBOutlet weak var circlelb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(model : MyNotesStruct?)
    {
        guard let model else {return}
        let fullName = "\(model.author?.fullName ?? " ") - Burbank Homes"
        let authorValue = (model.createdInMyHome ?? true) ? appDelegate.currentUser?.userDetailsArray?.first?.fullName ?? "--" : fullName
        let subject = "\(model.subject?.trim() ?? "--")"
        let body = "\(model.body?.trim() ?? "--")"

        authorNameLb.text = authorValue
        subjectLb.text = subject
        bodyLb.text = body
        bodyLb.numberOfLines = 1
    
        if let noteId = model.noteId
        {
            let jobNum = CurrentUser.jobNumber ?? ""
            if let isRead = UserDefaults.standard.value(forKey: "\(jobNum)_\(noteId)_isRead") as? Bool , isRead == true
            {
                circlelb.isHidden = true
            }
            else {
                circlelb.isHidden = false
                
            }
        }
        if model.replies?.count ?? 0 > 0
        {
            noteDateLb.text = "Replied on \(model.replies?.first?.displayDate ?? "--")"
        }else {
            noteDateLb.text = "Created on \(model.displayDate ?? "--")"
        }
        
    }

}
