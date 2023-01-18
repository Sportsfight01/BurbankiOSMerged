//
//  MyPlaceContactUsVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 27/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit
import Foundation

class MyPlaceContactUsVC: BurbankAppVC/*MyPlaceWithTabBarVC*/,UITableViewDelegate,UITableViewDataSource
    //UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
{
    
    
    //@IBOutlet weak var tabbarMenuCV: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!

    
    @IBOutlet weak var contactsTable: UITableView!
    
    @IBOutlet weak var noRecordLabel: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromCall = false
    let cellHeight: CGFloat = SCREEN_HEIGHT * 0.1
    let menuArray = [
        ["name" : "Call", "imageName" : "Ico-MyPlacePhone"],
        ["name" : "Email", "imageName" : "Ico-MyPlaceEmail"]]
    
    var namesarray = ["Faulty Dishwasher","Faulty Dishwasher","Request for paint colour code", "Request for paint colour code"]
//    var contactUsVICArray:[ContactUsVIC] = []
//    var contactUsQLDSAArray:[ContactUsQLDSA] = []
    
    var selectedInde = -1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setAppearanceFor(view: titleLabel, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.Black_BG, textFont: FONT_LABEL_HEADING(size: FONT_18))
        
        _ = setAttributetitleFor(view: titleLabel, title: "HistoryLog", rangeStrings: ["History", "Log"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_HEADING(size: FONT_18), FONT_LABEL_HEADING(size: FONT_18)], alignmentCenter: false)
        
        
//        menuTabBar.selectedItem = menuTabBar.items?[2]

        //tabbarMenuCV.dataSource = self
        //tabbarMenuCV.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)        
        
        noRecordLabel.isHidden = true
        
        if selectedJobNumberRegion == .OLD {
            if isContactUsServiceCalled == true {
                if contactUsVICArray.count == 0 {
                    noRecordLabel.isHidden = false
                    return
                }
            }
            else {
                callLogoutService()
            }
        }
        else
        {
            if isContactUsServiceCalled == true {
                if contactUsQLDSAArray.count == 0 {
                    noRecordLabel.isHidden = false
                    return
                }
            }
            else {
                callLogoutService()
            }
        }
        
    }
    
    
    
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {

        if self.navigationController?.viewControllers.count == 1 {
            
            self.tabBarController?.selectedIndex = 0
        }else {
            
            self.navigationController?.popViewController(animated: true)
        }

//        for vc: UIViewController in (navigationController?.viewControllers)! {
//            if (vc.isKind(of: MyPlaceDashBoardVC.self)) {
//                navigationController?.popToViewController(vc, animated: false)
//            }
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - CollectionView DataSource Methods
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        
//        return 2
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        let cellID = "CellID"
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MyPlaceContactUSCVCell
//        
//        let menuDic = menuArray[indexPath.row]
//        cell.menuImageView.image = UIImage(named: menuDic["imageName"]!)
//        cell.menuNameLabel.text = menuDic["name"]
//        
//        return cell
//    }
//    //Mark :- CollectionView Delegate Methods
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let mailMessage = "Need more information to implement E-Mail Functionality. Please provide more details. Before sending Email, customer will save comments (Subject and Body). But To Whom the customer will send EMail. Which Service to get the Emailid of responsible officer."
//        let callMessage = "Need more information to implement Call Functionality. Please provide more details. Before initiating call, customer will save call comments (Subject and Body). But To Whom the customer will call. Which Service to get the mobile number of responsible officer."
//        AlertManager.sharedInstance.alert(indexPath.row == 0 ? callMessage: mailMessage)
//        let postDic: [String : Any] = ["replytoid":344548,"subject":"Comment about progress", "stepid":3455,"body":"this is a very large text field, and could be 5000 or even 10000 bytes, or more.."]
//     
//        MyPlaceServiceSession.shared.callToPostDataToServer(myPlaceNotesURLString(), postDic, successBlock: { (json, response) in
//            //
//            print(json)
//        }, errorBlock:{ (error, isJSON) in
//            //
//        })
//
////        if indexPath.row == 0 {//            isFromCall = true
////            self.performSegue(withIdentifier: "ShowMyPlaceCallEmailVC", sender: nil)
////        }
////        else if indexPath.row == 2 {
////            isFromCall = false
////            self.performSegue(withIdentifier: "ShowMyPlaceCallEmailVC", sender: nil)
////        }
////        else {
////        AlertManager.sharedInstance.alert("Work in Progress")
////        }
//        
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        
//        let height = collectionView.frame.size.height
//        let width = collectionView.frame.size.width/2
//        return CGSize(width: width, height: height)
//    }
//    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if(selectedJobNumberRegion == .OLD)
         {
            
            return contactUsVICArray.count
        }
        else
         {
            return contactUsQLDSAArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactsUsCell2")as! MyPlaceContactUSCell
        
        cell.selectionStyle = .none
        
//        cell.imageLabel.layer.cornerRadius = cell.imageLabel.frame.width/2
//        cell.imageLabel.layer.masksToBounds = true
        
//        if selectedInde == indexPath.row {
//            cell.detailsLabel.numberOfLines = 0
//        }
//        else {
//            cell.detailsLabel.numberOfLines = 2
//        }
        
        if(selectedJobNumberRegion == .OLD)
        {
            if (contactUsVICArray.count > 0)
            {
                cell.titleLabel.text = contactUsVICArray[indexPath.row].subject
                cell.authorLabel.text = "By " + (contactUsVICArray[indexPath.row].authorname + "on " + contactUsVICArray[indexPath.row].notedateWithFormat)
                
                cell.detailsLabel.text = (contactUsVICArray[indexPath.row].body )
            }
        }
        else
        {
            if (contactUsQLDSAArray.count > 0)
            {
                #if DEDEBUG
                print(contactUsQLDSAArray[indexPath.row].authorname)
                #endif
                
                cell.titleLabel.text = contactUsQLDSAArray[indexPath.row].subject
                cell.authorLabel.text = "By " +  (contactUsQLDSAArray[indexPath.row].authorname + "on " + contactUsQLDSAArray[indexPath.row].notedateWithFormat)
                
                cell.detailsLabel.text = (contactUsQLDSAArray[indexPath.row].body )
            }
        }
        
        
        cell.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        
        cell.icon.superview?.layer.cornerRadius = (cell.icon.superview?.frame.size.height ?? 0)/2
        cell.icon.superview?.clipsToBounds = true

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let descriptionHeight = heightForView(contactUsQLDSAArray[indexPath.row].body, font: UIFont(name: "ProximaNova-Regular", size: 12.0)!, width: SCREEN_WIDTH-76)
        let charSize = UIFont(name: "ProximaNova-Regular", size: 12.0)!.lineHeight // Get label height based on Font
        var linesRoundedUp = Int(ceil(descriptionHeight/charSize)) // Get number of lines
        linesRoundedUp = linesRoundedUp-1
        
        if linesRoundedUp > 2 {
            
            if selectedInde == indexPath.row {
                selectedInde = -1
            }
            else {
                selectedInde = indexPath.row
            }
            
            tableView.reloadData()
        }
        
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        let dateText = "By" +  (contactUsQLDSAArray[indexPath.row].authorname + " on " + contactUsQLDSAArray[indexPath.row].notedateWithFormat)
//
//        // Top 10 + Label Height + Gap 5 + Date Label Height + Gap 5 + Label height + bottom 10
//
//
//        var descriptionHeight = heightForView(contactUsQLDSAArray[indexPath.row].body, font: UIFont(name: "ProximaNova-Regular", size: 12.0)!, width: SCREEN_WIDTH-76)
//        let charSize = UIFont(name: "ProximaNova-Regular", size: 12.0)!.lineHeight // Get label height based on Font
//        var linesRoundedUp = Int(ceil(descriptionHeight/charSize)) // Get number of lines
//        #if DEDEBUG
//        print("line numbers \(linesRoundedUp)")
//        #endif
//        linesRoundedUp = linesRoundedUp-1
//
//        // Show height for two lines
//        if linesRoundedUp > 2 {
//
//            if selectedInde != indexPath.row {
//                descriptionHeight = (descriptionHeight/3)*2
//            }
//        }
//
//        return 10 + heightForView(contactUsQLDSAArray[indexPath.row].subject, font: UIFont(name: "ProximaNova-SemiBold", size: 17.0)!, width: SCREEN_WIDTH-76) + 3 + heightForView(dateText, font: UIFont(name: "ProximaNova-SemiBold", size: 12.0)!, width: SCREEN_WIDTH-76) + 6 + descriptionHeight + 10 + 10
//
//
////        return 120
//    }
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMyPlaceCallEmailVC" {
            let destination = segue.destination as! MyPlaceCallEmailVC
            destination.isFromCall = isFromCall

        }
     }
    
    func callLogoutService()
    {
        if !ServiceSession.shared.checkNetAvailability()
        {
            return
        }
        
        let logoutURL = "\(getMyPlaceURL())login/logout/"
        var urlRequest = URLRequest(url: URL(string: logoutURL)!)
        urlRequest.httpMethod = kGet
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // print(data,response,error)
            if error != nil
            {
                #if DEDEBUG
                print("fail to Logout")
                #endif
                return
            }
            if let httpResponse = response as? HTTPURLResponse
            {
                #if DEDEBUG
                print("--->",httpResponse.statusCode)
                #endif
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 200
                    {
                        //sucess
                        self.callToCheckUser()
                    }
                }
            }
        }).resume()
    }
    func callToCheckUser()
    {
        guard  let myPlaceDetails = self.appDelegate.currentUser?.userDetailsArray?[0].myPlaceDetailsArray[0] else {return }
        let region = myPlaceDetails.region ?? ""
        let jobNumber = myPlaceDetails.jobNumber ?? ""
        let password = myPlaceDetails.password ?? ""
        let userName = myPlaceDetails.userName ?? ""
        // ServiceSessionMyPlace.sharedInstance.serviceConnection("POST", url: url, postBodyDictionary: ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password], serviceModule:"PropertyStatusService")
        let postDic =  ["Region": region, "JobNumber":jobNumber, "UserName":userName, "Password":password]
        //callMyPlaceLoginServie(myPlaceDetails)
        let url = URL(string: checkUserLogin())
        var urlRequest = URLRequest(url: url!)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpMethod = kPost
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: postDic, options:[])
        }
        catch {
            #if DEDEBUG
            print("JSON serialization failed:  \(error)")
            #endif
            
        }
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil
            {
                #if DEDEBUG
                print("fail to Logout")
                #endif
                return
            }
            if let strData = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
            {
                DispatchQueue.main.async {
                    if strData == "true"
                    {
                        //  self.getMyPlaceLoggedinUser()
                        self.callToGetDataFromUser()
                    }
                }
                
            }
        }).resume()
    }
    
    func callToGetDataFromUser()
    {
        MyPlaceServiceSession.shared.callToGetDataFromServer(getLoggedInUser(), successBlock: { (json, response) in
            
            isContactUsServiceCalled = true
            
            if let jsonDic = json as? [String: Any]
            {
                _ = MyPlaceStatusDetails(dic: jsonDic)
               // let jobNumber = myPlaceStatusDetails.jobNumber
                MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceNotesURLString(), successBlock: { (json, response) in
                    //
                    if let jsonArray = json as? NSArray
                    {
                        for obj in jsonArray
                        {
                            if let jsonDic = obj as? [String: Any]
                            {
                                if(selectedJobNumberRegion == .OLD)
                                {
                                    contactUsVICArray.append( ContactUsVIC(jsonDic))
                                }
                                else
                                {
                                    contactUsQLDSAArray.append(ContactUsQLDSA(jsonDic))
                                }
                            }
                        }
                        if(selectedJobNumberRegion == .OLD && contactUsVICArray.count == 0)
                        {
                            self.noRecordLabel.isHidden = false
                        }
                        else
                        {
                            self.noRecordLabel.isHidden = true
                        }
                        if(selectedJobNumberRegion != .OLD && contactUsQLDSAArray.count == 0)
                        {
                            self.noRecordLabel.isHidden = false
                        }
                        else
                        {
                            self.noRecordLabel.isHidden = true
                        }
                        
                        self.contactsTable.reloadData()
                    }
                    
                }, errorBlock: { (error, isJSON) in
                    //
                })
            }
        }, errorBlock: { (error, isJSONError) in
            //
            if isJSONError == false
            {
                AlertManager.sharedInstance.alert((error?.localizedDescription)!)
            }else
            {
            }
        })
    }
    
    
    
}
class MyPlaceContactUSCVCell: BurbankAppCVCell
{
    @IBOutlet weak var blackBackGroundView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuNameLabel: UILabel!
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        let height = SCREEN_HEIGHT * 0.35 * 0.8 * 0.5 //* 0.5
        blackBackGroundView.layer.cornerRadius =  height/2 //((SCREEN_HEIGHT * 0.4) - 10) * 0.5
        blackBackGroundView.layer.masksToBounds = true
    }
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
}


//func getLabelHeight(_ labelText: String, width : CGFloat, font : UIFont) -> CGFloat {
//    let constraint = CGSize(width: CGFloat(width), height: CGFloat(CGFloat.greatestFiniteMagnitude))
//    var size: CGSize
//    let context = NSStringDrawingContext()
//    let boundingBox: CGSize? = labelText.boundingRect(with: constraint, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: context).size
//    size = CGSize(width: CGFloat(ceil((boundingBox?.width)!)), height: CGFloat(ceil((boundingBox?.height)!)))
//    return size.height
//}

func heightForView(_ text:String, font:UIFont, width:CGFloat) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    
    label.sizeToFit()
    return label.frame.height
}


