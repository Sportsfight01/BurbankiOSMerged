//
//  MyPlaceContractVC.swift
//  Burbank
//
//  Created by Mohan Kumar on 24/10/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class MyPlaceContractVC: BurbankAppVC/*MyPlaceWithTabBarVC*/, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var titleLabel : UILabel!

    @IBOutlet var myPlaceContractTableView : UITableView!
    
    var namesArray = NSMutableArray()

    var appDelegate : AppDelegate!
    
    var myPlaceContractDictionary : NSMutableDictionary!
    var contractDetails : MyPlaceContractDetails!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        
        _ = setAttributetitleFor(view: titleLabel, title: "MyHomeDetails", rangeStrings: ["MyHome", "Details"], colors: [COLOR_BLACK, COLOR_ORANGE], fonts: [FONT_LABEL_HEADING(size: FONT_18), FONT_LABEL_HEADING(size: FONT_18)], alignmentCenter: false)
        
        appDelegate=UIApplication.shared.delegate as? AppDelegate
        
      //  print(" Contract Details %@",myPlaceContractDictionary)

        // Do any additional setup after loading the view.
      //  fillContractDetails()
        selectedJobNumberRegion == .OLD ? fillContractDetails() : fillContractDetailsForQLDSA()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        myPlaceContractTableView.reloadData()
    }
    
    
    
    func fillContractDetailsForQLDSA()
    {
        let jobNumber = contractDetails.job
        let jobAddress = contractDetails.jobAddress//myPlaceContractDictionary.value(forKey: "JobAddress")as? String ?? ""
        let homeStyle = contractDetails.houseType//myPlaceContractDictionary.value(forKey: "HomeStyle")as? String ?? ""
        let fecadeStyle = contractDetails.facadeStyle//myPlaceContractDictionary.value(forKey: "FacadeStyle")as? String ?? ""
        let contractStatus = contractDetails.jobStatus
        //let value = (myPlaceContractDictionary.value(forKey: "ContractValue") as? Int)
        let contractValue = String.currencyFormate(Int32(contractDetails.contractValue)) //NSString(format: "$%d", (myPlaceContractDictionary.value(forKey: "ContractValue") as? Int)!) as String
        var supervisor = contractDetails.supervisor
        let liason = contractDetails.homeCoOrdinator //"//myPlaceContractDictionary.value(forKey: "Liason")as? String ?? ""
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        print("siteStartDate--->\(contractDetails.siteStartDate)")
        //let siteDate = contractDetails.siteStartDate.stringToDateConverter()
        let siteDate = dateFormater.date(from: contractDetails.siteStartDate) ?? Date()
        //var startDate = dateFormater.string(from: siteDate)
        let weekNum = siteDate.dayNumberOfWeek() ?? 0
        let weekName = getWeekName(weekNum: weekNum)
        let monthID = siteDate.monthNumber
        let monthName = getMonthNameWith(id: monthID)
        let day = siteDate.dayValue
        let year = siteDate.presentYear
        var displayString = "\(weekName),\(monthName),\(day),\(year)"
        
    
        if supervisor == "" {
            supervisor = "--"
            displayString = "--"
        }
        
        namesArray = [
            ["name" : "Job Number", "value" : jobNumber],
            ["name" : "Home Address", "value" : jobAddress],
            ["name" : "Home Style", "value" : homeStyle],
            ["name" : "Facade Style", "value" : fecadeStyle],
//            ["name" : "Home Status", "value" : contractStatus],
            ["name" : "Home Value", "value" : contractValue],
            ["name" : "Site Supervisor", "value" : supervisor],
            ["name" : "New Home Coordinator", "value" : liason]]
//            ["name" : "Site Start Date", "value" : displayString]]    ---> changes by naveen on 26/May/2022
    }
    
    func fillContractDetails() {
        let jobNumber = myPlaceContractDictionary.value(forKey: "JobNumber")as? String ?? ""
        let jobAddress = myPlaceContractDictionary.value(forKey: "JobAddress")as? String ?? ""
        let homeStyle = myPlaceContractDictionary.value(forKey: "HomeStyle")as? String ?? ""
        let fecadeStyle = myPlaceContractDictionary.value(forKey: "FacadeStyle")as? String ?? ""
        let contractStatus = myPlaceContractDictionary.value(forKey: "ContractStatus")as? String ?? ""
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_AU") // This is the default
        let value = (myPlaceContractDictionary.value(forKey: "ContractValue") as? Int) ?? 0
        let contractValue = formatter.string(from: NSNumber(value: value))//NSString(format: "$%d", (myPlaceContractDictionary.value(forKey: "ContractValue") as? Int)!) as String
        var supervisor = myPlaceContractDictionary.value(forKey: "Supervisor")as? String ?? ""
        let liason = myPlaceContractDictionary.value(forKey: "Liason")as? String ?? ""
        var startDate = myPlaceContractDictionary.value(forKey: "SiteStartDate")as? String ?? ""
//        let clientName = myPlaceContractDictionary.value(forKey: "ClientName")as? String ?? ""
//        let homePhoneNumber = myPlaceContractDictionary.value(forKey: "HomePhoneNumber")as? String ?? ""
//        let mobilePhoneNumber = myPlaceContractDictionary.value(forKey: "MobilePhoneNumber")as? String ?? ""
//        let email = myPlaceContractDictionary.value(forKey: "Email")as? String ?? ""
//        let workPhoneNumber = myPlaceContractDictionary.value(forKey: "WorkPhoneNumber")as? String ?? ""
        print(supervisor)
        if supervisor == "" {
            supervisor = "--"
            startDate = "--"
        }
        
        
        
        namesArray = [
            ["name" : "Job Number", "value" : jobNumber],
            ["name" : "Home Address", "value" : jobAddress],
            ["name" : "Home Style", "value" : homeStyle],
            ["name" : "Facade Style", "value" : fecadeStyle],
//            ["name" : "Home Status", "value" : contractStatus],
            ["name" : "Home Value", "value" : contractValue],
            ["name" : "Site Supervisor", "value" : supervisor],
            ["name" : "New Home Coordinator", "value" : liason]]
//            ["name" : "Site Start Date", "value" : startDate]]
    }
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return namesArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myPlaceContractCell = tableView.dequeueReusableCell(withIdentifier: "MyPlaceContractIdentifier", for: indexPath) as! MyPlaceContractCell
        myPlaceContractCell.nameLabel.text = ((namesArray.object(at: indexPath.row) as AnyObject).value(forKey: "name") as! String)
        let value = ((namesArray.object(at: indexPath.row) as AnyObject).value(forKey: "value") as? String) ?? ""
        let trimmedValue = value.replacingOccurrences(of: "\r\n", with: " ")
        myPlaceContractCell.valueLabel.text = trimmedValue
        myPlaceContractCell.selectionStyle = .none
      
        myPlaceContractCell.layoutIfNeeded()
        myPlaceContractCell.valueLabel.layoutIfNeeded()
        
        return myPlaceContractCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableView.automaticDimension
////        return IS_IPHONE_5 ? 60.0 : 80.0
////        return 80
    }
//
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
        //        return 60
    }


}
