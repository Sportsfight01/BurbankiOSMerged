//
//  ResetOptionVC.swift
//  BurbankApp
//
//  Created by dmss on 01/02/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit
protocol resetOptionDelegate
{
    func resetToAllHomes()
}

class ResetOptionVC: UIViewController
{
    var delegate: resetOptionDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.65)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Button Actions
    @IBAction func canceButtonTapped(sender: AnyObject)
    {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func resetButtonTapped(sender: AnyObject)
    {
        delegate?.resetToAllHomes()
        dismiss(animated: true, completion: nil)
    }
}
