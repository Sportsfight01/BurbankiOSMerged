//
//  DisolayHomeFilterSelectionView.swift
//  BurbankApp
//
//  Created by dmss on 21/04/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import Foundation
import UIKit

protocol DisplayHomeFilterSelectionProtocal
{
    func filterOptionSelectedWith(value: String)
}
class DisolayHomeFilterSelectionView: UIControl,UITableViewDataSource,UITableViewDelegate
{
    var tableView : UITableView! = {
        
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    var selectionListArray = [String]()
    let cellIdentifier = "CellID"
    var delegate: DisplayHomeFilterSelectionProtocal?
    override var alpha: CGFloat
        {
        didSet
        {
            tableView.reloadData()
        }
    }
    override init(frame: CGRect)
    {
        //code
        super.init(frame: frame)
        addSubview(tableView)
        tableView.backgroundColor = UIColor.white
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier:cellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return selectionListArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) //as! DisplayLocationsCell
        cell.textLabel?.text = selectionListArray[indexPath.row]
        cell.textLabel?.font = ProximaNovaRegular(size: 10.0)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        if indexPath.row == 0
        {
            cell.backgroundColor = UIColor.lightGray
        }else
        {
            cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 20//tableView.frame.size.height/CGFloat(selectionListArray.count)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        alpha = 0
        
        delegate?.filterOptionSelectedWith(value: selectionListArray[indexPath.row])
    }
    
    
}
