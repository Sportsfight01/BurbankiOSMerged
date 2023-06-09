//
//  DocumentsTBCell.swift
//  BurbankApp
//
//  Created by naresh banavath on 30/11/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import UIKit

class DocumentsTBCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "DocumentsTBCell"
    
    @IBOutlet weak var docIconImgView: UIImageView!
    @IBOutlet weak var pdfNameLb: UILabel!
    @IBOutlet weak var uploadedOnDateLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [pdfNameLb,uploadedOnDateLb].forEach({ label in
            label?.numberOfLines = 1
        })
        pdfNameLb.font = FONT_LABEL_SUB_HEADING(size: FONT_12)
        uploadedOnDateLb.font = FONT_LABEL_SUB_HEADING(size: FONT_12)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setup(model : DocumentsDetailsStruct)
    {
        pdfNameLb.text = "\(model.title ?? "Title").\(model.type ?? "pdf")"
        if let notedate = model.docdate?.components(separatedBy: ".").first
        {
            let notedated = dateFormatter(dateStr: notedate, currentFormate: "yyyy-MM-dd'T'HH:mm:ss", requiredFormate: "dd MMM, yyyy, hh:mm a")
            uploadedOnDateLb.text = "Uploaded on: \(notedated ?? "- -")"
        }
      
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
    
}
