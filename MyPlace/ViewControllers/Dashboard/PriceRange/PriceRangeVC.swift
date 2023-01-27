//
//  TopView.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 17/04/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import UIKit
import WARangeSlider

class PriceRangeVC: UIViewController {
    
    @IBOutlet private weak var rangesliderView: UIView!
    @IBOutlet weak var lBrange: UILabel!
    @IBOutlet weak var barGraph: UICollectionView!
    
    
    var rangeslider = RangeSlider()
    
    
    var searchType: Int?
    
    
    var bars = [0, 0, 0, 0, 0, 0, 0]
    var priceListArr = [NSDictionary]()
    var bars_alpha = [0.4, 0.6, 0.8, 1, 0.8, 0.6, 0.4]
    
    var Spacing: CGFloat = 5.0
    var selectedBarValue = 0
    
    lazy var width_cell: CGFloat = {
        return (self.barGraph.frame.size.width - (CGFloat(bars.count) - 1)*Spacing)/CGFloat(bars.count)
    }()
    
    
    var updatedPriceRangeValues: (() -> Void)?
    
    var tapedOnBarPriceRangeValues: (() -> Void)?
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pageUISetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateRangeSlider ()
    }
    
    
    //MARK: - View setUp
    
    func pageUISetup () {
        
        setAppearanceFor(view: view, backgroundColor: COLOR_CLEAR)
        
        setAppearanceFor(view: lBrange, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.GreyTextFont, textFont: FONT_LABEL_SUB_HEADING (size: FONT_18))
        
        barGraph.register(BarGraphCell.self, forCellWithReuseIdentifier: "BarGraphCell")
        
        
        rangesliderView.addSubview(rangeslider)
        
        
        rangeslider.trackHighlightTintColor = APPCOLORS_3.GreyTextFont
        
        rangeslider.trackTintColor = APPCOLORS_3.LightGreyDisabled_BG
        
        rangeslider.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
        
    }
    
    func updateRangeSlider () {
        
        rangeslider.frame = rangesliderView.bounds
        barGraph.reloadData()
        
    }
    
    
    
    //MARK: - RangeSlider Action
    
    @objc func handleValueChanged () {
        
        let upperValue = "\(rangeslider.upperValue)"
        let lowerValue = "\(rangeslider.lowerValue)"
        
        let upValue = (rangeslider.upperValue*1000).kmFormatted
        let lowValue = (rangeslider.lowerValue*1000).kmFormatted
        print("$\(lowValue ?? "") to $\(upValue ?? "")")
        
        lBrange.text = "$\(lowValue ?? "") to $\(upValue ?? "")"
        
        
        if let sendUpdates = updatedPriceRangeValues {
            sendUpdates ()
        }
    }
    
    //MARK: - View Updates
    
    func updateRangeSliderValues (with filter: SortFilter) {
        
        searchType = filter.searchType
        
        let frameee = rangeslider.frame
        
        for viewss in rangesliderView.subviews {
            viewss.removeFromSuperview()
        }
        
        
        rangeslider = RangeSlider(frame: frameee)
        rangesliderView.addSubview(rangeslider)
        
        rangeslider.trackHighlightTintColor = APPCOLORS_3.GreyTextFont
        rangeslider.trackTintColor = APPCOLORS_3.LightGreyDisabled_BG
        
        rangeslider.addTarget(self, action: #selector(handleValueChanged), for: .valueChanged)
        
        
        
        setDefaultSliderValues(filter.defaultPriceRange)
        setSliderValues(filter.priceRange)
        self.priceListArr = filter.priceRange.priceRangeList
        
        self.barGraph.reloadData()
        
    }
    
    func setDefaultSliderValues (_ priceRange: PriceRange) {
        
        rangeslider.maximumValue = priceRange.priceEnd
        rangeslider.minimumValue = priceRange.priceStart
        
    }
    
    func setSliderValues (_ priceRange: PriceRange) {
        
        rangeslider.upperValue = priceRange.priceEnd
        rangeslider.lowerValue = priceRange.priceStart
        
        let upValue = (priceRange.priceEnd*1000).kmFormatted
        let lowValue = (priceRange.priceStart*1000).kmFormatted
        print("$\(lowValue ) to $\(upValue )")
        lBrange.text = "$\(lowValue ) to $\(upValue )"
    }
    
}

//MARK: - Delegates

extension PriceRangeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let current = CGFloat(bars[indexPath.row])
        let max = CGFloat(bars.max()!)
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BarGraphCell", for: indexPath) as! BarGraphCell
        
        if current == 0, max == 0 {
            cell.frame.size.height = 1 * (barGraph.frame.size.height/1)
            
            if cell.frame.size.height > 22 {
                cell.frame.size.height = 22
            }
        }else {
            cell.frame.size.height = current * (barGraph.frame.size.height/max)
        }
        
        if cell.frame.size.height < 22 {
            cell.frame.size.height = 22
        }
        
        
        cell.rangeCount = "\(bars[indexPath.row])"
        
        cell.backgroundColor = COLOR_CLEAR
        cell.contentView.backgroundColor = COLOR_CLEAR
        cell.lBBG.backgroundColor = APPCOLORS_3.Orange_BG.withAlphaComponent(CGFloat(bars_alpha[indexPath.row]))
        
        
        cell.lBBG.layer.cornerRadius = radius_3
        cell.lBBG.clipsToBounds = true
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BarGraphCell
        cell.lBBG.backgroundColor = APPCOLORS_3.Orange_BG.withAlphaComponent(CGFloat(bars_alpha[indexPath.row]))
        print(indexPath.row)
//        Double(exactly: (dict.value(forKey: "MinPrice") ?? 0) as! NSNumber)!
        if Int(exactly: self.priceListArr[indexPath.item].value(forKey: "Price") as! NSNumber)  == bars[indexPath.row]{
        var priceMIN: Double = 0
        var priceMAX: Double = 1
        priceMIN =  Double(exactly: (self.priceListArr[indexPath.item].value(forKey: "MinPrice") ?? 0) as! NSNumber)!
//            Double(self.priceListArr[indexPath.item].value(forKey: "MinPrice") as! String) ?? 0.0
        priceMAX = Double(exactly: (self.priceListArr[indexPath.item].value(forKey: "MaxPrice") ?? 0) as! NSNumber)!
         //   priceMAX = priceMAX  + 1000
            if priceMIN > 1000 {
                priceMIN = Double(Int(priceMIN/1000))
            }
            if priceMAX > 1000 {
                priceMAX = Double(Int(priceMAX/1000))
            }
         //   print(priceMAX)
//            print(priceMIN)
            rangeslider.upperValue = priceMAX
            print(rangeslider.upperValue)
            rangeslider.lowerValue = priceMIN
            
            let upperValue = "\(rangeslider.upperValue)"
            let lowerValue = "\(rangeslider.lowerValue)"
            
            let upValue = (rangeslider.upperValue*1000).kmFormatted
            let lowValue = (rangeslider.lowerValue*1000).kmFormatted
            print("$\(lowValue ?? "") to $\(upValue ?? "")")
            
            
            lBrange.text = "$\(lowValue ?? "") to $\(upValue ?? "")"
            self.selectedBarValue = bars[indexPath.row]
            if let sendUpdates = tapedOnBarPriceRangeValues {
                sendUpdates ()
            }
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: width_cell, height: barGraph.frame.size.height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return Spacing
    }
    
}



//MARK: - Bar Graph CollectionViewCell

class BarGraphCell: UICollectionViewCell {
    
    var lBCount: UILabel = UILabel()
    var lBBG: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var rangeCount: String? {
        didSet {
            
            lBCount.text = self.rangeCount
            
            self.lBBG.frame = self.bounds
            
            lBCount.frame.origin.y = 5
            lBCount.frame.size.height = 15
            
            lBCount.frame.size.height = 20 > self.frame.size.height ? (self.frame.size.height - 5) : 15
            
        }
    }
    
    
    func addView () {
        
        self.addSubview(lBBG)
        self.addSubview(lBCount)
        
        lBBG.frame = self.bounds
        
        
        lBCount.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 15 > self.frame.size.height ? self.frame.size.height : 15)
        lBCount.backgroundColor = COLOR_CLEAR
        lBCount.textAlignment = NSTextAlignment.center
        
        setAppearanceFor(view: lBCount, backgroundColor: COLOR_CLEAR, textColor: APPCOLORS_3.HeaderFooter_white_BG, textFont: FONT_LABEL_SUB_HEADING (size: FONT_10))
    }
    
}





