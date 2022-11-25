//
//  MyPlaceCallEmailVC.swift
//  BurbankApp
//
//  Created by Mohan Kumar on 22/05/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class MyPlaceCallEmailVC: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var callorEmailTable: UITableView!
    @IBOutlet weak var headerLabel: UILabel!
    
    var isFromCall: Bool!
    
    @IBOutlet weak var callView: UIView!
    @IBOutlet weak var emailView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearanceFor(view: headerLabel, backgroundColor: COLOR_CLEAR, textColor: COLOR_BLACK, textFont: FONT_LABEL_HEADING(size: FONT_18))

        
        if isFromCall == true {
            headerLabel.text = "Call"
        }
        else {
            headerLabel.text = "Mail"
        }

        callView.isHidden = true
        emailView.isHidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        callView.isHidden = true
        emailView.isHidden = true

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func  tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CallorEmailCell") as! MyPlaceCallEmailCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromCall == true {
            callView.isHidden = false
        }
        else {
            emailView.isHidden = false
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

class MyPlaceCallEmailCell: UITableViewCell {
    @IBOutlet weak var nameLabel : UILabel!
    @IBOutlet weak var designationLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
}
