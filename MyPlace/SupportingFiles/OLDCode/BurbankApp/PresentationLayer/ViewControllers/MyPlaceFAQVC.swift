//
//  MyPlaceFAQVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 09/06/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class MyPlaceFAQVC: BurbankAppVC, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var faqTable: UITableView!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var answerPopUpBackGroudView: UIView!
    @IBOutlet weak var popUpQuestionLabel: UILabel!
    @IBOutlet weak var popUpAnswerTextView: UITextView!
    var selectedIndex = -1
    
    var faqArray: NSMutableArray!
    var responseArray: NSMutableArray!
    
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        faqArray = NSMutableArray()
        responseArray = NSMutableArray()
        
        
        fillFAQ()
        setUpAnswerPopUpView()
        
        viewSetUp ()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        faqTable.reloadData()
    }
    func setUpAnswerPopUpView()
    {
        self.view.bringSubviewToFront(answerPopUpBackGroudView)
        answerPopUpBackGroudView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        answerPopUpBackGroudView.alpha = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func viewSetUp () {
                
        titleLabel.text = "FAQ's" + " - \(selectedJobNumberRegionString)"

        _ = setAttributetitleFor(view: titleLabel, title: titleLabel.text ?? "", rangeStrings: ["FAQ's -", "\(selectedJobNumberRegionString)"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_HEADING(size: FONT_18), FONT_LABEL_HEADING(size: FONT_18)], alignmentCenter: false)
        
        setAppearanceFor(view: popUpQuestionLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Orange_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_14))

        setAppearanceFor(view: nextBtn, backgroundColor: APPCOLORS_3.Orange_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_15))
        setAppearanceFor(view: previousBtn, backgroundColor: APPCOLORS_3.Black_BG, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_15))

        setAppearanceFor(view: popUpAnswerTextView, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY(size: FONT_14))
        
        
        nextBtn.layer.cornerRadius = radius_5
        previousBtn.layer.cornerRadius = radius_5

    }
    
    
    
    
    
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func popUpPreviousButtonTapped(sender: AnyObject?)
    {
        if selectedIndex > 0
        {
            selectedIndex = selectedIndex - 1
            fillAnswerPopUpView()
        }else
        {
            showAlert()
        }
    }
    @IBAction func popUpNextButtonTapped(sender: AnyObject?)
    {
        if selectedIndex < faqArray.count - 1
        {
            selectedIndex = selectedIndex + 1
            fillAnswerPopUpView()
        }else
        {
            showAlert()
        }
    }
    @IBAction func popUpCloseButtonTapped(sender: AnyObject?)
    {
        hidePopUpView()
    }
    func showAlert()
    {
        AlertManager.sharedInstance.showAlert(alertMessage: "FAQ's are Completed", title: "")
        hidePopUpView()
    }
    func hidePopUpView()
    {
        UIView.animate(withDuration: 0.5) { 
            self.answerPopUpBackGroudView.alpha = 0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell", for: indexPath) as! faqCell
        
//        let id = (faqArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Id")as! String?
        
        let question = (faqArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Question")as! String?
        let answer = (faqArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Answer")as! String?
        
        cell.questionLabel.text = String(format: "Q%d :  %@", indexPath.row+1, question!).replacingOccurrences(of: "&quot;", with: "\"")
        
        _ = setAttributetitleFor(view: cell.questionLabel, title: cell.questionLabel.text ?? "", rangeStrings: [String(format:"Q%d :", indexPath.row+1)], colors: [APPCOLORS_3.Black_BG], fonts: [FONT_LABEL_SUB_HEADING(size: FONT_14)], alignmentCenter: false)
        
        
//        let a = String(format: "%@", answer!).replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)

        cell.answerLabel.textColor = UIColor.black
        
        
//        let myString = String(format: "%@", answer!).convertHtml()
//        let myAttribute = [NSAttributedString.Key.zone: UIFont(name: "Chalkduster", size: 18.0)!]
//        let myAttrString = NSAttributedString(string: myString, attributes: myAttribute)
//
//        // set attributed text on a UILabel
//        cell.answerLabel.attributedText = myAttrString
        
        
        cell.selectionStyle = .none
        
        if selectedIndex != indexPath.row {
            cell.answerLabel.isHidden = true
            cell.dropDownImageView.image = #imageLiteral(resourceName: "Ico-DownNew")
            cell.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            cell.questionLabel.superview?.backgroundColor = APPCOLORS_3.EnabledOrange_BG
            
            cell.answerLabelTop.constant = 0
            cell.answerLabelBottom.constant = 0
            
            cell.answerLabel.text = ""
        }
        else {
            cell.answerLabel.isHidden = false
            cell.dropDownImageView.image = #imageLiteral(resourceName: "Ico-TopNew")
            cell.backgroundColor = APPCOLORS_3.Body_BG
            cell.questionLabel.superview?.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG.withAlphaComponent(0.8)
            cell.answerLabel.superview?.backgroundColor = APPCOLORS_3.HeaderFooter_white_BG.withAlphaComponent(0.6)
            
            cell.questionView.backgroundColor = UIColor.hexCode("F8A052")

            
            
            cell.answerLabelTop.constant = 10
            cell.answerLabelBottom.constant = 10
            
            cell.answerLabel.text = String(format: "%@", answer!).replacingOccurrences(of: "<br>", with: "\n", options: String.CompareOptions.regularExpression, range: nil).replacingOccurrences(of: "<li>", with: "\n \u{2022} ", options: String.CompareOptions.regularExpression, range: nil).replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil).replacingOccurrences(of: "&#8226;", with: "\n \u{2022}").replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "&#34", with: "!").replacingOccurrences(of: "Yu", with: "You").replacingOccurrences(of: "<[^li]+>", with: "\n \u{2022}", options: String.CompareOptions.regularExpression, range: nil)
            
            
        }
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! faqCell
        
        if cell.answerLabel.isHidden == false
        {
            UIView.animate(withDuration: 0.5, animations: { 
                self.answerPopUpBackGroudView.alpha = 1
            })
            selectedIndex = indexPath.row
            fillAnswerPopUpView()
        }else
        {
//            if selectedIndex == indexPath.row {
//                selectedIndex = -1
//            }
//            else {
//                selectedIndex = indexPath.row
//            }
            selectedIndex = indexPath.row
        }
       
        
        tableView.reloadData()
    }
    func fillAnswerPopUpView()
    {
        let faqDic = faqArray[selectedIndex] as! NSDictionary //we already know
//        let id = faqDic.value(forKey: "Id") as! String
        
        let question = faqDic.value(forKey: "Question") as! String
        let answer = faqDic.value(forKey: "Answer") as! String

        popUpQuestionLabel.text = String(format: "Q%d:   %@", selectedIndex+1, question).replacingOccurrences(of: "&quot;", with: "\"")
        
//        _ = setAttributetitleFor(view: popUpQuestionLabel, title: popUpQuestionLabel.text ?? "", rangeStrings: [String(format:"Q%d:", selectedIndex+1)], colors: [APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_HEADING(size: FONT_14)], alignmentCenter: false)

        
        popUpAnswerTextView.text = String(format: "%@", answer).replacingOccurrences(of: "<br>", with: "\n", options: String.CompareOptions.regularExpression, range: nil).replacingOccurrences(of: "<li>", with: "\n \u{2022} ", options: String.CompareOptions.regularExpression, range: nil).replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil).replacingOccurrences(of: "&#8226;", with: "\n \u{2022}").replacingOccurrences(of: "&quot;", with: "\"").replacingOccurrences(of: "&#34", with: "!").replacingOccurrences(of: "Yu", with: "You")
        
        if selectedIndex == 0 {
            previousBtn.isHidden = true
            nextBtn.isHidden = false
        }
        else if selectedIndex == faqArray.count-1 {
            previousBtn.isHidden = false
            nextBtn.isHidden = true
        }
        else if faqArray.count == 1 {
            previousBtn.isHidden = true
            nextBtn.isHidden = true
        }
        else {
            previousBtn.isHidden = false
            nextBtn.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if selectedIndex == indexPath.row {
            return UITableView.automaticDimension
        }

//        if selectedIndex == indexPath.row {
//            let answer = (faqArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Answer")as! String?
//            let labelSize = rectForText(text: answer!, font: UIFont.systemFont(ofSize: 17), maxSize: CGSize(width: UIScreen.main.bounds.size.width-20, height: 999))
//            return labelSize.height+60
//        }
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    
    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSAttributedString.Key.font:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size
    }
    
    
    func getBasedOnState() {
        
        let regionDataArray = NSMutableArray()
        
        for obj in responseArray {
            
            let dict = obj as? NSDictionary
            
            if dict!["stageId"] as? String == selectedJobNumberRegionString {
                regionDataArray.add(dict!)
            }
        }
        
        faqArray = regionDataArray
        
        self.faqTable.reloadData()
        
    }
    
    func fillFAQ() {
        
        #if DEDEBUG
        print(selectedJobNumberRegionString)
        #endif
//        selectedJobNumberRegion == .VLC
        
        if UserDefaults.standard.value(forKey: "GET_FAQ_LIST") != nil {
            responseArray = UserDefaults.standard.value(forKey: "GET_FAQ_LIST") as? NSMutableArray
            
//            #if DEDEBUG
//            print(responseArray)
//            #endif
            if responseArray == nil {
                
            }
            else {
                self.getBasedOnState()
                return
            }
            
            
        }
        
        ServiceSession.shared.callToGetDataFromServerWithGivenURLString("https://www.burbank.com.au/myplace/AngularScripts/FAQ/Services/faq.json", withactivity: true) { (json) in
            if let jsonArray = json as? NSArray {
                self.responseArray = jsonArray.mutableCopy() as? NSMutableArray
            
                UserDefaults.standard.setValue(self.responseArray, forKey: "GET_FAQ_LIST")
                
                self.getBasedOnState()
            }
        }
        
        
//        faqArray =
//            [ [
//                "Id":"1",
//                "Question":"WHAT IS THE FIRST HOME OWNER GRANT (FHOG)?",
//                "Answer":"FHOG was introduced in July 2000 to help offset the effect of GST on home ownership. A one-off grant is currently payable by the Federal and/or State Government until 30th June to first home buyers who meet the eligibility criteria. Further information is available via your lender."
//                ],
//              [
//                "Id":"2",
//                "Question":"WHEN WILL I RECEIVE THE PAYMENT?",
//                "Answer":"Payment is made to your lender as part of the first progress payment of your Building Contract."
//                ],
//              [
//                "Id":"3",
//                "Question":"WHAT IS A CONTRACT OF SALE?",
//                "Answer":" A document prepared by an estate agent or solicitor outlining particulars of the sale of a property. It clarifies details such as price, settlement, finance and any special conditions."
//                ],
//              [
//                "Id":"4",
//                "Question":"WHAT IS A VENDOR STATEMENT?",
//                "Answer":"Also known as a Section 32, this is attached to the Contract of Sale and provides the buyer with information about the sale of the property. As it is important to check this document thoroughly, it is a good idea to have your solicitor peruse it before an offer to a Vendor is signed."
//                ],
//              [
//                "Id":"5",
//                "Question":" WHAT IS A BUILDING CONTRACT?",
//                "Answer":"A document between you and your builder which includes details of start and completion dates, new home specifications, contract price and progress payments."
//                ],
//              [
//                "Id":"6",
//                "Question":"WHAT DOES COOLING-OFF MEAN?",
//                "Answer":"A “Cooling-Off period” occurs within 3 business days from the date of contract signing allowing the potential buyer to withdraw from the deal. A cooling-off period of 5 business days applies to building contracts over $5000."
//                ],
//              [
//                "Id":"7",
//                "Question":"WHAT IS VCAT?",
//                "Answer":"The Victorian Civil and Administrative Tribunal (VCAT) is a low cost forum facilitating dispute hearings regarding consumer matters, including domestic building works, where both parties are unable to reach agreement."
//                ],
//              [
//                "Id":"8",
//                "Question":"WHAT IS STAMP DUTY?",
//                "Answer":"A State Government tax imposed on the sale of real estate (includes both established homes and land purchases) and determined by the sale value. Your solicitor or lender can calculate the stamp duty payable when buying a property."
//                ],
//              [
//                "Id":"9",
//                "Question":" WHAT ARE COVENANTS?",
//                "Answer":"Restrictions placed on your land which set the requirements for the size of your new home, including the style or type of materials used. These will be outlined in the Section 32 Vendor Statement. Protecting your investment, Covenants regulate the standard of homes in an estate. Most new estates also have specific Developer Guidelines, which the buyer must comply with. Your builder can assist you with these when selecting your new home."
//                ],
//              [
//                "Id":"10",
//                "Question":"WHAT IS RESCODE?",
//                "Answer":" A Victorian Government Code which sets out the development standards for housing, land subdivisions and town planning."
//                ],
//              [
//                "Id":"11",
//                "Question":"WHAT IS A PLANNING PERMIT?",
//                "Answer":"A statement specifying a particular use or development may proceed on a specific piece of land."
//                ],
//              [
//                "Id":"12",
//                "Question":"HOW DO I KNOW IF I NEED TO APPLY FOR PLANNING PERMIT?",
//                "Answer":"The best way to find out whether you need a Planning Permit is to contact your local Council. Generally, this will be required when subdividing land or demolishing a house. Depending on the Council, you may require one to build a new home."
//                ],
//              [
//                "Id":"13",
//                "Question":"WHAT IS A SOIL TEST?",
//                "Answer":"This is carried out on your block to determine the soil conditions. By drilling a series of holes and analyzing the contents, soil conditions can be determined to enable an engineer to design the footings of your new home."
//                ],
//              [
//                "Id":"14",
//                "Question":"WHAT IS A SITE CLASSIFICATION?",
//                "Answer":"This is determined by the engineer from assessment of the soil test results.\nThe classes include:\nS - Slightly reactive\nM - Moderately reactive\nH - Highly reactive\nE - Extremely reactive\nP - Problem sites\nClasses S,M,H and E generally refer to sites with clay soils and how reactive the soil is to changes in moisture content which can impact on the footings/slab."
//                ],
//              [
//                "Id":"15",
//                "Question":"WHAT ARE PIERS?",
//                "Answer":"These are support mechanisms usually made from poured concrete under the slab of a home. Often used where there is ‘fill’ on site. Engineers determine if these are required in the design of your footings."
//                ],
//              [
//                "Id":"16",
//                "Question":"WHAT IS SITE FALL?",
//                "Answer":"The amount of slope on your block, determined by a series of contour lines shown on a feature survey."
//                ],
//              [
//                "Id":"17",
//                "Question":"WHAT DOES CUT AND FILL MEAN?",
//                "Answer":"The method used to provide a level building area on a sloping site where part of the surface is cut away and used to provide fill on the area of the slope below it."
//                ],
//              [
//                "Id":"18",
//                "Question":"WHAT IS A FEATURE SURVEY AND WHO CONDUCTS THIS?",
//                "Answer":"A licenced surveyor will visit the site and prepare a Feature Survey by locating features particular to the site, including fences, trees, pits, adjacent buildings, ground level and contours. The survey will also determine the site fall/slope of the land. This is displayed as a series of contour lines at different levels. Your builder orders this information."
//                ],
//              [
//                "Id":"19",
//                "Question":"WHAT IS A RE-ESTABLISHMENT SURVEY?",
//                "Answer":"This survey is an accurate identification of a property boundary. Your builder will sometimes order this from a licenced surveyor before the construction of your home begins."
//                ],
//              [
//                "Id":"20",
//                "Question":"WHAT IS AN EASEMENT?",
//                "Answer":" A section of land registered on the Certificate of Title providing Council or utility providers right of access to your property. Often pipes such as sewer or storm water are in the easement. You may not build a house or other permanent structure over an easement without consent."
//                ],
//              [
//                "Id":"21",
//                "Question":"WHAT IS A SITING?",
//                "Answer":"Your proposed new home is placed onto your block of land. Your sales consultant will site your home to scale, taking care to comply with the regulatory requirements, including building envelopes and developer guidelines."
//                ],
//              [
//                "Id":"22",
//                "Question":"WHAT IS A BUILDING ENVELOPE?",
//                "Answer":"A designated area on your land within which all building work must be contained. A building envelope is registered on your title by the Council and will be shown in the Plan of Subdivision attached to the Vendor Statement."
//                ],
//              [
//                "Id":"23",
//                "Question":"WHAT IS A SETBACK?",
//                "Answer":"The minimum allowable distance from the front boundary of the block to the front of your home."
//                ],
//              [
//                "Id":"24",
//                "Question":"WHAT ARE SITE COSTS?",
//                "Answer":"Costs which arise from placing a home  onto your land, including service connection costs. These include leveling of the building area, connection to sewer and storm water,removal of trees, piering under the slab, connection to power etc."
//                ],
//              [
//                "Id":"25",
//                "Question":"WHAT IS A CROSSOVER?",
//                "Answer":"The kerb opening to your lot installed by the Council to allow vehicle access to the property. It is important to check the location of your crossover when siting your new home."
//                ],
//              [
//                "Id":"26",
//                "Question":"WHAT IS A FAÇADE?",
//                "Answer":"The front or face of a house."
//                ],
//              [
//                "Id":"27",
//                "Question":"WHAT DOES ROOF PITCH MEAN?",
//                "Answer":"The angle of a sloping roof, usually expressed in degrees, eg. 22 degree pitch."
//                ],
//              [
//                "Id":"28",
//                "Question":"WHAT IS A VARIATION ORDER?",
//                "Answer":" An alteration to a standard design or building specification."
//                ],
//              [
//                "Id":"29",
//                "Question":"WHAT IS DEVELOPER APPROVAL?",
//                "Answer":"Developer Approval of your building plans is applied for by your builder on your behalf. The developer will check your new home complies with all estate requirements."
//                ],
//              [
//                "Id":"30",
//                "Question":"WHAT IS A BUILDING PERMIT?",
//                "Answer":"A building permit must be granted before the construction of your new home commences. This ensures the construction plans and engineering comply with all relevant building regulations and have been approved by a registered building surveyor."
//                ],
//              [
//                "Id":"31",
//                "Question":"WHAT IS AN OCCUPANCY PERMIT?",
//                "Answer":"Also called a Certificate of Occupancy, this document is issued by a Building Surveyor after final inspection of your new home. It certifies your home is ready to move into."
//                ],
//              [
//                "Id":"32",
//                "Question":"HELPFUL LINKS",
//                "Answer":"http://www.firsthome.gov.au\nhttp://www.sro.vic.gov.au\nhttp://www.npfs.com.au\nhttp://www.burbank.com.au\nhttp://www.mbav.com.au\nhttp://www.reiv.com.au\nhttp://www.vcat.com.au\nhttp://www.buildingcommission.com.au"
//                ]
//        ]
    }
}

class faqCell: UITableViewCell {

    @IBOutlet weak var questionLabel : UILabel!
    @IBOutlet weak var answerLabel : UILabel!
    @IBOutlet weak var dropDownImageView : UIImageView!
    @IBOutlet weak var questionView: UIView!

    @IBOutlet weak var answerLabelTop : NSLayoutConstraint!
    @IBOutlet weak var answerLabelBottom : NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setAppearanceFor(view: questionLabel, backgroundColor: questionLabel.backgroundColor ?? COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_14))
        
        setAppearanceFor(view: answerLabel, backgroundColor: answerLabel.backgroundColor ?? COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_BODY (size: FONT_13))

    }
    
    
}

extension String{
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
            ]
            
            return try NSAttributedString(data: data, options: options, documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}

//cell.lblHeader.attributedText = try NSAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)


//[NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue]
