//
//  MyPlaceMyAppointmentsVC.swift
//  BurbankApp
//
//  Created by Apple on 1/3/18.
//  Copyright © 2018 DMSS. All rights reserved.
//


import UIKit


class MyPlaceMyAppointmentsVC: BurbankAppVC/*MyPlaceWithTabBarVC*/,UITableViewDelegate,UITableViewDataSource  {
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var appointmentsTable: UITableView!
    
    @IBOutlet weak var headerNameLabel: UILabel!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var isFromCall = false
    let cellHeight: CGFloat = SCREEN_HEIGHT * 0.1
    let menuArray = [
        ["name" : "Call", "imageName" : "Ico-MyPlacePhone"],
        ["name" : "Email", "imageName" : "Ico-MyPlaceEmail"]]
    
    var namesarray = ["Edge Appointment",
                      "Electrical Selection",
                      "Sign Building Contract",
                      "Tender Presentation",
                      "PC Inspection"]
//    var appointmentsVICDate:[String] = ["","","","",""]
//    var appointmentsQLDDate:[String] = ["","","","",""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = setAttributetitleFor(view: titleLabel, title: "MyAppointments", rangeStrings: ["My","Appointments"], colors: [APPCOLORS_3.Black_BG, APPCOLORS_3.Orange_BG], fonts: [FONT_LABEL_HEADING(size: FONT_18), FONT_LABEL_HEADING(size: FONT_18)], alignmentCenter: false)
        
        
        
        //        menuTabBar.selectedItem = menuTabBar.items?[1]
        appointmentsTable.dataSource = self
        appointmentsTable.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isAppointmentServiceCalled == false {
            callLogoutService()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return namesarray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell")as! MyPlaceAppointmentsCell
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "dd MMM yyyy"
        
        cell.appointmentType.text = namesarray[indexPath.row]
        
        if(selectedJobNumberRegion == .OLD)
        {
//            if(appointmentsVICDate.count > indexPath.row)
//            {
//                if let dataActual = appointmentsVICDate[indexPath.row] as? String
//                {
//                    var dateFormatter = dataActual.displayDateFormateString()
//                    if dateFormatter == ""
//                    {
//                        dateFormatter = " - - "
//                    }
//                    cell.appointmentDate.text =  dateFormatter
//                }
//            }
        }
        else
        {
            if(appointmentsQLDDate.count > indexPath.row)
            {
                //if
                    let dataActual = appointmentsQLDDate[indexPath.row] //{
                    
                    var dateFormatter = dataActual.displayDateFormateString()
                    if dataActual == "" || dataActual == "- -"
                    {
                        dateFormatter = " - - "
                    }
                    cell.appointmentDate.text =  dateFormatter
                //}
            }
        }
        
        if cell.appointmentType.text == "PC Inspection" {
            cell.appointmentDate.text = " - - "
        }
       
        //        if(selectedJobNumberRegion == .VLC)
        //        {
        //            if (contactUsVICArray.count > 0)
        //            {
        //                cell.titleLabel.text = contactUsVICArray[indexPath.row].subject
        //                cell.authorLabel.text = "By" + (contactUsVICArray[indexPath.row].authorname + " on " + contactUsVICArray[indexPath.row].notedate)
        //
        //                cell.detailsLabel.text = (contactUsVICArray[indexPath.row].body )
        //            }
        //        }
        //        else
        //        {
        //            if (contactUsQLDSAArray.count > 0)
        //            {
        //                cell.titleLabel.text = contactUsQLDSAArray[indexPath.row].subject
        //                cell.authorLabel.text = "By" +  (contactUsQLDSAArray[indexPath.row].authorname + " on " + contactUsQLDSAArray[indexPath.row].notedate)
        //
        //                cell.detailsLabel.text = (contactUsQLDSAArray[indexPath.row].body )
        //            }
        //        }
        
        
        cell.icon.superview?.layer.cornerRadius = cell.icon.superview!.frame.size.height/2

        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 1 || indexPath.row == 3 {
            return 0
        }
        
        return UITableView.automaticDimension
    }
    
    
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
                print("--->",httpResponse.statusCode)
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
            print("JSON serialization failed:  \(error)")
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
            
            if let _ = json as? [String: Any]
            {
                //let myPlaceStatusDetails = MyPlaceStatusDetails(dic: jsonDic)
               // let jobNumber = myPlaceStatusDetails.jobNumber
                MyPlaceServiceSession.shared.callToGetDataFromServer(myPlaceProgressDetailsURLString(), successBlock: { (json, response) in
                    var progressDetails:MyPlaceProgressDetails
                    //var progressDetailsVIC: MyPlaceProgressDetailsVIC
                    if let jsonArray = json as? NSArray
                    {
                        for obj in jsonArray
                        {
                            
                            if let jsonDic = obj as? [String: Any]
                            {
                                #if DEDEBUG
                                print(jsonDic)
                                #endif
                                
                                isAppointmentServiceCalled = true
                                
                                    if selectedJobNumberRegion == .OLD
                                    {
//                                       progressDetailsVIC = MyPlaceProgressDetailsVIC(dic: jsonDic)
//
//                                        if (progressDetailsVIC.name == "Edge Appointment")
//                                        {
//                                            appointmentsVICDate[0] = progressDetailsVIC.dateCompleted
//                                        }
//                                        else if (progressDetailsVIC.name  == "Electrical Selection")
//                                        {
//                                            appointmentsVICDate[1] = progressDetailsVIC.dateCompleted
//                                        }
//                                        else if (progressDetailsVIC.name == "Sign Building Contract")
//                                        {
//                                            appointmentsVICDate[2] = progressDetailsVIC.dateCompleted
//                                        }
//                                        else if (progressDetailsVIC.name == "Tender Presentation")
//                                        {
//                                            appointmentsVICDate[3] = progressDetailsVIC.dateCompleted
//                                        }
//                                        else if (progressDetailsVIC.name == "PC INSPECTION")
//                                        {
//                                            appointmentsVICDate[4] = progressDetailsVIC.dateCompleted
//                                        }
                                        
                                    }
                                else
                                    {
                                        progressDetails = MyPlaceProgressDetails(dic: jsonDic)
                            
                                        
                                        print("---\(progressDetails.name)--\(progressDetails.dateActual)--")
                                        
                                        
                                        if (progressDetails.name == "Edge Appointment" || progressDetails.name == "Colour Selection")
                                        {
                                            if (progressDetails.status.lowercased() == "completed")
                                            {
                                                appointmentsQLDDate[0] = progressDetails.dateActual
                                                
                                            }
                                            else
                                            {
                                                appointmentsQLDDate[0] = "- -"
                                            }
//                                            appointmentsQLDDate[0] = progressDetails.dateActual
                                        }
                                        else if (progressDetails.name == "Electrical Selection")
                                        {
//                                            appointmentsQLDDate[1] = progressDetails.dateActual
                                            if (progressDetails.status.lowercased() == "completed")
                                            {
                                                appointmentsQLDDate[1] = progressDetails.dateActual
                                                
                                            }
                                            else
                                            {
                                                appointmentsQLDDate[1] = "- -"
                                            }
                                        }
                                        else if (progressDetails.name == "Sign Building Contract")
                                        {
                                            if (progressDetails.status.lowercased() == "completed")
                                            {
                                                appointmentsQLDDate[2] = progressDetails.dateActual
                                                
                                            }
                                            else
                                            {
                                                appointmentsQLDDate[2] = "- -"
                                            }
//                                            appointmentsQLDDate[2] = progressDetails.dateActual
                                        }
                                        else if (progressDetails.name == "Tender Presentation")
                                        {
//                                            appointmentsQLDDate[3] = progressDetails.dateActual
                                            if (progressDetails.status.lowercased() == "completed")
                                            {
                                                appointmentsQLDDate[3] = progressDetails.dateActual
                                                
                                            }
                                            else
                                            {
                                                appointmentsQLDDate[3] = "- -"
                                            }
                                        }
                                        else if (progressDetails.name == "PC INSPECTION")
                                        {
//                                            appointmentsQLDDate[4] = progressDetails.dateActual
                                            if (progressDetails.status.lowercased() == "completed")
                                            {
                                                appointmentsQLDDate[4] = progressDetails.dateActual
                                                
                                            }
                                            else
                                            {
                                                appointmentsQLDDate[4] = "- -"
                                            }
                                        }
                                    }
                                    //self.contactUsQLDSAArray.append(ContactUsQLDSA(jsonDic))
                                }
                        }
                        
                        #if DEDEBUG
                        print("-------------",appointmentsQLDDate)
                        #endif
                        
//                        print(appointmentsVICDate)
                        
                        self.appointmentsTable.reloadData()
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


class MyPlaceContactUSVCCell: BurbankAppCVCell
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
