//
//  FiltersOptionVC.swift
//  BurbankApp
//
//  Created by imac on 10/01/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import UIKit

class FiltersOptionVC: UIViewController {

    @IBOutlet weak var smallFilterView: UIView!
    @IBOutlet weak var bigFilterView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bigFilterView.isHidden = true
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

    @IBAction func zoomOutTapped(sender: AnyObject)
    {
        
        
        self.smallFilterView.isHidden = true
        self.bigFilterView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, options: .transitionCurlUp, animations: {
            //
            
        }, completion: nil)
        //        bigFilterView.alpha = 0.0
//                UIView.animate(withDuration: 0.4, animations: {
//                    self.smallFilterView.alpha = 0
//                }) { (finished) in
//                    self.bigFilterView.alpha = 1.0
//                    self.smallFilterView.isHidden = true
//                    self.bigFilterView.isHidden = false
//                }
    }
    @IBAction func zoomInTappaed(sender:AnyObject)
    {
//        smallFilterView.isHidden = false
//        bigFilterView.isHidden = true
       self.smallFilterView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.bigFilterView.isHidden = true
        }, completion: nil)
        
//        UIView.animate(withDuration: 0.4, animations: {
//            
//        }) { (finished) in
//            
//        }
    }
}
