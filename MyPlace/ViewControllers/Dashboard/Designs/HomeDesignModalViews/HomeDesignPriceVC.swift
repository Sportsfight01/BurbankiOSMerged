//
//  HomeDesignPriceVC.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 15/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit

class HomeDesignPriceVC: HomeDesignModalHeaderVC {
    
    //    @IBOutlet weak var contentView: UIView!
    
    
    
    @IBOutlet weak var price_lBPrice: UILabel!
    
//    @IBOutlet weak var price_btnContinue: UIButton!
//    @IBOutlet weak var price_btnSkip: UIButton!
    
    @IBOutlet weak var priceRangeContainerView: UIView!
    
    
    var priceRangeVC: PriceRangeVC?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        priceViewSetUp ()
        
    }
    
    
    
    func priceViewSetUp () {
        
        setAppearanceFor(view: price_lBPrice, backgroundColor: COLOR_CLEAR, textColor: COLOR_DARK_GRAY, textFont: FONT_LABEL_BODY (size: FONT_19))
        
//        setAppearanceFor(view: price_btnContinue, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_BODY(size: FONT_14))
//        setAppearanceFor(view: price_btnSkip, backgroundColor: COLOR_ORANGE, textColor: COLOR_WHITE, textFont: FONT_BUTTON_BODY(size: FONT_14))
        
//        price_btnSkip.layer.cornerRadius = radius_5
//        price_btnContinue.layer.cornerRadius = radius_5
        
        
        priceRangeVC?.updatedPriceRangeValues = {
            
            let lowerValue = NSNumber(value: NSNumber (value: self.priceRangeVC?.rangeslider.lowerValue ?? 0).intValue).stringValue
            let upperValue = NSNumber(value: NSNumber (value: self.priceRangeVC?.rangeslider.upperValue ?? 0).intValue).stringValue
            
            self.homeDesignFeature?.selectedMinPrice = lowerValue
            self.homeDesignFeature?.selectedMaxPrice = upperValue
            
            
           
            self.homeDesignFeature?.displayString = "$\(lowerValue)K - $\(upperValue)K"
            
            
            if let selection = self.selectionUpdates {
                selection (self)
            }
        }
        
    }
    
    
    //MARK: - DefaultValues Slider
    
    func setFeaturePriceValues () {
        
        if let minprice = homeDesignFeature?.minValue, let maxprice = homeDesignFeature?.maxValue {
            
            if minprice > 0, maxprice > 0 {
                setFeaturePriceValues(with: minprice, maxPrice: maxprice)
            }
        }
    }
    
    
    
    func setFeaturePriceValues (with minPrice: Double, maxPrice: Double, countDistribution: [Int] = [0, 0, 0, 0, 0, 0, 0]) {

        var lowerPrice = minPrice
        var upperPrice = maxPrice
        

        
        if lowerPrice > 999 {
            lowerPrice = lowerPrice/1000
            
            self.homeDesignFeature?.selectedMinPrice = NSNumber(value: Int(lowerPrice)).stringValue
        }
        
        if upperPrice > 999 {
            upperPrice = upperPrice/1000
            
            self.homeDesignFeature?.selectedMaxPrice = NSNumber(value: Int(upperPrice+1)).stringValue
        }
        
        
        let priceRange = PriceRange ()
        priceRange.priceStart = lowerPrice
        priceRange.priceEnd = upperPrice + 1
        
        if let min = self.homeDesignFeature?.selectedMinPrice, let max = self.homeDesignFeature?.selectedMaxPrice {
            self.homeDesignFeature?.displayString = "$\(min)K - $\(max)K"
        }

        
        
        priceRangeVC?.setDefaultSliderValues (priceRange)
        priceRangeVC?.setSliderValues (priceRange)
        
        priceRangeVC?.bars = countDistribution
        priceRangeVC?.barGraph.reloadData()

    }
    
    
    //MARK: - View Updates
    
    override func reloadView() {
        super.reloadView()
        
    }
    
    //MARK: - Clear
    
    override func clearSelections () {
        super.clearSelections()
        
    }
    
    
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "priceRange" {
            
            priceRangeVC = segue.destination as? PriceRangeVC
            priceRangeVC?.searchType = SearchType.shared.newHomes
            
//            priceRangeVC?.updatedPriceRangeValues = {
//
//
//            }
        }
        
    }
    
    
}


extension Double {
    var kmFormatted: String {
//       self = self*1000

        if self >= 10000, self <= 999999 {
            return String(format: "%.1fK", locale: Locale.current,self/1000).replacingOccurrences(of: ".0", with: "")
        }

        if self > 999999 {
            return String(format: "%.1fM", locale: Locale.current,self/1000000).replacingOccurrences(of: ".0", with: "")
        }

        return String(format: "%.0f", locale: Locale.current,self)
    }
}
