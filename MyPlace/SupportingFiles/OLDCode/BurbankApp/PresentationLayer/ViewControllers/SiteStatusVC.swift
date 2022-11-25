//
//  SiteStatusVC.swift
//  Burbank
//
//  Created by Madhusudhan on 03/08/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

class SiteStatusVC: BurbankAppVC/*MyPlaceWithTabBarVC*/, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var imageCollection : UICollectionView!
    
    @IBOutlet weak var displayImageView : UIImageView!
    
    @IBOutlet weak var previousButton : UIButton!
    
    @IBOutlet weak var nextButton : UIButton!

    var imagesArray : NSMutableArray!
    
    @IBOutlet weak var imageDateLabel : UILabel!
    
    var lastSelectedIndex = 0

    var imageTimer = Timer()
    
    // MARK: View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        #if DEDEBUG
//        print(imagesArray)
//        #endif
        
        previousButton.isEnabled = false
        
        if imagesArray.count<=1 {
            nextButton.isEnabled = false
        }
        
        if imagesArray.count != 0 {
            showTheImage()
        }
        
        CodeManager.sharedInstance.setLabelsFontInView(self.view)

        /**
         Notification Center to handle Timer
         */
        NotificationCenter.default.addObserver(self, selector: #selector(SiteStatusVC.timerStart), name: NSNotification.Name(rawValue: "TIMER_HANDLE"), object: nil)
    }
    // MARK: - Button Actions
    @IBAction func backButtonTapped(sender: AnyObject) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     collection view delegate methods
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    /**
     make a cell for each cell index path
     */
    // MARK : Madhusudhan  -- madhusudhanreddyp@dmss.co.in
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "statusCollectionCell", for: indexPath) as! CollectionViewCell

        
        var urlString = (imagesArray.object(at: indexPath.row) as! NSDictionary).value(forKey: "ImagePath") as! String
        
        urlString = urlString.replacingOccurrences(of: " ", with: "")
        
        let url = URL(string: urlString)
        
        cell.myImage.setImageWith(url!, placeholderImage: UIImage(named: ""))
        
        
        if displayImageView.tag == indexPath.row {
            
            cell.myImage.layer.borderColor = UIColor.orangeBurBankColor().cgColor
            cell.myImage.layer.borderWidth = 3.0
        }
        else {
            cell.myImage.layer.borderColor = UIColor.clear.cgColor
            cell.myImage.layer.borderWidth = 1.0
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        imageTimer.invalidate()
        
        previousButton.isEnabled = true
        nextButton.isEnabled = true
        
        let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as! CollectionViewCell
        
        displayImageView.image = cell.myImage.image
        
        displayImageView.tag = indexPath.row
        
        imageCollection.reloadData()
        
        if displayImageView.tag==0 {
            previousButton.isEnabled = false
            return
        }
        
        if imagesArray.count==displayImageView.tag+1 {
            nextButton.isEnabled = false
            return
        }
    }
    
    @IBAction func prevAndNextTapped(_ sender : AnyObject) {
        
        previousButton.isEnabled = true
        nextButton.isEnabled = true
        
        if sender as? UIButton == previousButton {
            
            if displayImageView.tag < imagesArray.count {
                
                displayImageView.tag = displayImageView.tag-1
                
                if displayImageView.tag<imagesArray.count-(Int(SCREEN_WIDTH/100)) {
                    
                    if displayImageView.tag>Int(SCREEN_WIDTH/100) {
                        var x_Position : CGFloat = (100*CGFloat(displayImageView.tag))
                        
                        x_Position = (x_Position-(SCREEN_WIDTH-100))
                        
                        imageCollection.contentOffset=CGPoint(x: x_Position, y: 0)
                    }
                    else {
                        imageCollection.contentOffset=CGPoint(x: 100*displayImageView.tag, y: 0)
                    }
                    
                }
            }
        }
        else {
            if imagesArray.count > displayImageView.tag {
                
                displayImageView.tag = displayImageView.tag+1
                
                if displayImageView.tag>Int(SCREEN_WIDTH/100) {
                    var x_Position : CGFloat = (100*CGFloat(displayImageView.tag))
                    
                    x_Position = (x_Position-(SCREEN_WIDTH-100))
                    
                    imageCollection.contentOffset=CGPoint(x: x_Position, y: 0)
                }
            }
        }
        
        showTheImage()
        
        imageCollection.reloadData()
        
        if imageTimer.isValid == false {
            
            #if DEDEBUG
            print("asdasdasd")
            #endif
            
            self.timerStart()
        }
    }
    
    func showTheImage() {
        
        var urlString = (imagesArray.object(at: displayImageView.tag) as! NSDictionary).value(forKey: "ImagePath") as! String
        
        urlString = urlString.replacingOccurrences(of: " ", with: "")
        
        let url = URL(string: urlString)
        
        self.displayImageView.setImageWith(url!, placeholderImage: UIImage(named: ""))
        
        
        // Converting date format
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyy-MM-dd"
        
        let dateStr = ((imagesArray.object(at: displayImageView.tag) as! NSDictionary).value(forKey: "DateUploaded") as! NSString).substring(to: 10)

       let date : Date! = dateFormatter.date(from: dateStr)! as Date
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat="dd/MM/yyyy"
        
        // Converting time format 24 hour to 12 hour
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat="HH:mm:ss"
        
        let timeStr = ((imagesArray.object(at: displayImageView.tag) as! NSDictionary).value(forKey: "DateUploaded") as! NSString).substring(with: NSRange(location: 11, length: 8))
        
        let time : Date! = timeFormatter.date(from: timeStr)! as Date
        
        let timeFormatter1 = DateFormatter()
        timeFormatter1.dateFormat="h:mm:ss a"
        
        imageDateLabel.text = NSString(format: "Site photos - date taken: %@ %@", dateFormatter1.string(from: date),timeFormatter1.string(from: time))as String
        
        if displayImageView.tag==0 {
            previousButton.isEnabled = false
            return
        }
        
        if imagesArray.count==displayImageView.tag+1 {
            nextButton.isEnabled = false
            return
        }
    }
    
    // MARK:
    // MARK: TIMER METHODS
    /**
     Timer START
     */
    @objc func timerStart() {
        
        imageTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(SiteStatusVC.timerTrigger), userInfo: nil, repeats: true)
    }
    
    
    @objc func timerTrigger() {

        #if DEDEBUG
        print("Your running Timer")
        #endif
        
        if imagesArray.count-1 > displayImageView.tag {
            self.prevAndNextTapped(nextButton)
        }
        else
        {
            displayImageView.tag=0
            self.prevAndNextTapped(nextButton)
            imageCollection.contentOffset=CGPoint(x: 0, y: 0)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
