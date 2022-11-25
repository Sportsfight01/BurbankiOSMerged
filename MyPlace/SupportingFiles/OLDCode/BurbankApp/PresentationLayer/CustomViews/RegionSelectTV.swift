//
//  RegionSelectTV.swift
//  BurbankApp
//
//  Created by dmss on 11/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

protocol regionSelectedProtocol
{
    func regionSelectedWith(region: [String: Any])
}

class RegionSelectTV: UIView,UITableViewDataSource,UITableViewDelegate
{
    var delegate: regionSelectedProtocol?
 
    var regionListTableView : UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.regionListTableView = UITableView()
        self.regionListTableView.frame = frame
        self.regionListTableView.register(RegionListTVCell.self, forCellReuseIdentifier: "CellID")
        self.regionListTableView.dataSource = self
        self.regionListTableView.delegate = self
        self.regionListTableView.isScrollEnabled = false
        self.addSubview(self.regionListTableView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    var regionListArray : NSMutableArray = [["Name" : "Victoria" , "Code" : "VIC"],["Name" : "Queensland" , "Code" : "QLD"],["Name" : "South Australia" , "Code" : "SA"],["Name" : "New South Wales /\nAustralian Capital Territory" , "Code" : "NSW/ACT"]]
    //["Name" : "New South Wales" , "Code" : "NSW"]
    // MARK: - TableView DataSource Methods
    internal func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.separatorStyle = .none
        // #warning Incomplete implementation, return the number of rows
        return regionListArray.count
    }
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath) as! RegionListTVCell
        let regionName = (regionListArray[indexPath.row] as AnyObject).value(forKey: "Name") as? String
        cell.region = regionName
        if indexPath.row == regionListArray.count
        {
            cell.bottomLine.isHidden = true
        }
        return cell
        
    }
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //let cell = tableView.cellForRow(at: indexPath) as! RegionListTVCell
                
        let regionString = (regionListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Name") as! String?
        //For Temporary we are storing in userdefaults,we need to change it to post and get from Server.(if we use DB we need to store it with UserDetails)
        
        let regionCode = ((regionListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Code") as! String?)!
        
        let currentRegion: [String: Any] = ["Name": regionString! ,"regionCode": regionCode]
        UserDefaults.standard.set(currentRegion, forKey: "currentRegion")
        
        delegate?.regionSelectedWith(region: currentRegion)
       
       // tableView.reloadData()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let regionCode = ((regionListArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "Code") as! String?)!
        let height = CGFloat(tableView.frame.size.height/CGFloat(regionListArray.count))
        if regionCode == "NSW/ACT"
        {
            return height + 8
        }else
        {
            return height - 2.667
        }
    }

}
