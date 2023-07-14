//
//  ContactUsReplyTBCell.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 07/06/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import UIKit

class ContactUsReplyTBCell: UITableViewCell {

    @IBOutlet weak var replyTitleLb: UILabel!    
    @IBOutlet weak var authorLb: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeStampLb: UILabel!
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
        guard let data = model else {return}
        if let body = data.body , body.trim().count > 0
        {
            if data.isFromAdmin == false { // reply from mobile(customer)
                let fromMessage = (model?.authorname == nil ? "" : " - Message from \(model!.authorname!)")
                let replyTitle = "\(body)  " + fromMessage
                setAttributetitleFor(view: replyTitleLb, title: replyTitle, rangeStrings: [body,fromMessage], colors: [.label,.label], fonts: [regularFontWith(size: 14.0), regularFontWith(size: 14)], alignmentCenter: false)
            }else // it is from admin
            {
                replyTitleLb.text = body
            }
           
        }
        
        let notedate = dateFormatter(dateStr: data.notedate?.components(separatedBy: ".").first ?? "", currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd MMM yyyy, hh:mm a")
        timeStampLb.text = notedate
        //containerView.cardView()
        authorLb.text = "\(model?.authorname ?? " ")"
        cardView()
        
    }
    func dateFormatter(dateStr : String , currentFormate : String , requiredFormate : String) -> String?
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = currentFormate
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = requiredFormate
        
        if let date = dateFormatterGet.date(from: dateStr) {
            return dateFormatterPrint.string(from: date)
        } else {
            return nil
        }
    }
    func cardView()
    {
        containerView.backgroundColor = .white
        containerView.layer.masksToBounds = false
        containerView.layer.cornerRadius = 7.0
        containerView.layer.shadowColor = UIColor.white.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        containerView.layer.shadowRadius = 3.0
        containerView.layer.shadowOpacity = 0.5
    }
}
