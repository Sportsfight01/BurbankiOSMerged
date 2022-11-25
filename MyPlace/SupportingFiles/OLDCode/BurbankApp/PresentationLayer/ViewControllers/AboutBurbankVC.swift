//
//  AboutBurbankVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 23/05/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class AboutBurbankVC: BurbankAppVC {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var privacyPolicyWebview: UIWebView!

    var isFromAboutUs: Bool!
    var isFromTerms: Bool!
    var isFromPrivacy: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearanceFor(view: headerLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_18))

        
        privacyPolicyWebview.isHidden = true
        setTextViewData()
        
        textView.textContainerInset = UIEdgeInsets.init(top: 10, left: 15, bottom: 10, right: 15)
        
    }

    @IBAction func backButtonTapped(sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setTextViewData() {
        if isFromAboutUs == true {
            headerLabel.text = "About Burbank"
            privacyPolicyWebview.isHidden = false
            if let urlPath = Bundle.main.path(forResource: "AboutUS", ofType: "html")
            {
                DispatchQueue.main.async {
                    self.privacyPolicyWebview.loadRequest(URLRequest(url: URL(fileURLWithPath: urlPath, isDirectory: false)))
                }
                
            }
            
        }
       else if isFromTerms == true {
            headerLabel.text = "Terms of Use"
            
               let str = NSString(format: "%@", "Copyright conditions:\n\nAll photos and illustrations are representative and are to be used as a guide only. Floorplans and specifications may be varied by Burbank without notice, the dimensions are diagrammatic only and a Building Contract with final drawings will display the final dimensions and detail. The inclusion of furniture, floor coverings, wall paper, artwork, curtains, light fittings, lawns, planter boxes, fences, driveways, footpaths, patios and pergolas are intended merely as a guide and are not included in the price unless otherwise listed independently. All designs are the property of Burbank Group and must not be used, reproduced, copied or varied, wholly or in part without written permission from an authorised Burbank representative. All information provided on Burbank Group websites is provided for information purposes only and does not constitute a legal contract between Burbank Australia and any person or entity unless otherwise specified. This information is subject to change without prior notice. And while every reasonable effort is made to ensure current and accurate information is presented, Burbank Australia makes no guarantees of any kind. At times sites under Burbank Australia’s control may link to external sites or may contain community-based forums. Burbank Australia does not control, monitor or guarantee the information contained in these sites or information contained in links to other external websites, and does not endorse any views expressed or products or services offered therein. In no event shall Burbank Australia be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with the use of or reliance on any such content, goods, or services available on or through any such site or resource.")
            
            textView.text = str as String
            
//            _ = setAttributetitleFor(view: textView, title: <#T##String#>, rangeStrings: <#T##[String]#>, colors: <#T##[UIColor]#>, fonts: <#T##[UIFont]#>, alignmentCenter: <#T##Bool#>)
            
            
            
            let rangeStr = "Copyright conditions:"
            let rangeStr2 = (str as String).replacingOccurrences(of: "Copyright conditions:", with: "")

            let attr = NSMutableAttributedString(string: str as String)

            attr.addAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, .font: FONT_LABEL_SUB_HEADING(size: FONT_14)], range: str.range(of: rangeStr))
            attr.addAttributes([NSAttributedString.Key.foregroundColor: COLOR_BLACK, .font: FONT_LABEL_BODY (size: FONT_12)], range: str.range(of: rangeStr2))

            textView.attributedText = attr
            
            
            textView.isEditable = false
        }else if isFromPrivacy == true {
            headerLabel.text = "Privacy Policy"
            privacyPolicyWebview.isHidden = false
            
            if let urlPath = Bundle.main.path(forResource: "Privacy Policy", ofType: "html")
            {
                DispatchQueue.main.async {
                    self.privacyPolicyWebview.loadRequest(URLRequest(url: URL(fileURLWithPath: urlPath, isDirectory: false)))
                }
                
            }
            
        }
    }
}
