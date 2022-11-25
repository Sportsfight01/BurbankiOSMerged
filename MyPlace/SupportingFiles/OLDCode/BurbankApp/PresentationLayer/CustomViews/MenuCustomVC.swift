//
//  MenuCustomVC.swift
//  Burbank
//
//  Created by dmss on 21/09/16.
//  Copyright © 2016 DMSS. All rights reserved.
//

import UIKit

protocol performSegueDelegate
{
    func showSegueViewController(_ index: Int)
}

class MenuCustomVC: NSObject,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout
{

    var menuArray = NSArray()
    var mydelegate : performSegueDelegate? = nil
    
    // MARK: - collectionView Datasource
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //need to change
        return menuArray.count//8
    }
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "menuCell", for: indexPath) as! MenuCVCell
        
        setUpCell(cell: cell, indexPath: indexPath)
        
        return cell
        
    }
    func setUpCell(cell: MenuCVCell, indexPath: IndexPath)
    {
        cell.menuNameLabel.text = ""
        cell.menuIconImageView.image = nil
//        if indexPath.row == 7 || indexPath.row == 6 {
//            cell.horizontalLineImageView.isHidden = true
//        }
//        
//        if indexPath.row % 2 != 0 {
//            cell.verticalLineImageView.isHidden =  true
//        }
        
        if indexPath.row < menuArray.count {
            cell.menuIconImageView.image = UIImage(named: (menuArray.object(at: indexPath.row) as AnyObject).value(forKey: "imageName") as! String)
            cell.menuNameLabel.text = (menuArray.object(at: indexPath.row) as AnyObject).value(forKey: "name") as? String
        }
//        if indexPath.row == menuArray.count - 1
//        {
//            cell.menuIconCenterXConstraint.isActive = false
//            cell.newMenuIconCenterXConstraint.isActive = true
//            cell.menuNameLabelCenterXConstraint.isActive = true
//            cell.menuNameLabelTopConstraint.isActive = false
//            
//        }else
//        {
//            cell.menuIconCenterXConstraint.isActive = true
//            cell.newMenuIconCenterXConstraint.isActive = false
//            cell.menuNameLabelCenterXConstraint.isActive = false
//            cell.menuNameLabelTopConstraint.isActive = true
//        }
    }
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    //    {
    //        return UIEdgeInsetsZero
    //
    //    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let   width = collectionView.frame.size.width/3
        let  height = collectionView.frame.size.height/2 //: CGFloat = 0
        
//        if menuArray.count == 5 {
//            height = collectionView.frame.size.height/3
//            if indexPath.row == 4
//            {
//                width = collectionView.frame.size.width
//            }
//        }
//        //if menuArray.count == 7
//        else {
//            
//            height = collectionView.frame.size.height/4
//            
//            if indexPath.row == 6 {
//                width = collectionView.frame.size.width
//            }
//        }
//        
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    // MARK: - collectionView Delegates
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mydelegate!.showSegueViewController(indexPath.row)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
  
}
