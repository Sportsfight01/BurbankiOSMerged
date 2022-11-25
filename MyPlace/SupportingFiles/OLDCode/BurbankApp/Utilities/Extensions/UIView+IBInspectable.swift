//
//  UIView+IBInspectable.swift
//  Burbank
//
//  Created by dmss on 06/09/16.
//  Copyright © 2016 DMSS. All rights reserved.
//


/*:
 
 #Overview
 
 This is for extentions of UI Elements for Corner Radius, Border Width , Border color and Image saving in cache.
 
 */

import Foundation
import UIKit

//extension UIView
//{
//
//    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
//        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        layer.mask = mask
//    }
//
//    /**
//
//     The radius to use when drawing rounded corners for the layer’s background.
//     The default value of this property is 0.0.
//     The property can display in Drag and drop file to change value for Every UIView element
//     */
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//
//    /**
//
//     The width of the layer’s border.
//     The default value of this property is 0.0.
//     The property can display in Drag and drop file to change value for Every UIView element
//     */
//    @IBInspectable var borderWidth: CGFloat {
//        get {
//            return layer.borderWidth
//        }
//        set {
//            layer.borderWidth = newValue
//        }
//    }
//
//    /**
//
//     The color of the layer’s border.
//     The default value of this property is an opaque black color.
//     The property can display in Drag and drop file to change value for Every UIView element
//     */
//    @IBInspectable var borderColor: UIColor? {
//        get {
//            return UIColor(cgColor: layer.borderColor!)
//        }
//        set {
//            layer.borderColor = newValue?.cgColor
//        }
//    }
//
//
//    /**
//     A Boolean value that determines whether the view is hidden.
//     Setting the value of this property to true hides the receiver and setting it to false shows the receiver. The default value is false.
//     */
//    func isMyHidden()
//    {
//        if isHidden == true
//        {
//            isHidden = false
//        }
//        else if isHidden == false
//        {
//            isHidden = true
//        }
//    }
//    func changeAlpha()
//    {
//        if alpha == 0.0
//        {
//            alpha = 1.0
//        }else if alpha == 1.0
//        {
//            alpha = 0.0
//        }
//    }
//}

//extension UITextField {
//
//    @IBInspectable var placeHolderColor: UIColor? {
//        get {
//            return self.placeHolderColor
//        }
//        set {
//            self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedString.Key.foregroundColor: newValue!])
//        }
//    }
//
//}

/*:
 
 #Overview
 
 This is for extentions of UIImageView saving loaded image in cache.
 
 */

//let imageCache = NSCache<NSString, UIImage>()

//extension UIImageView
//{
//    /**
//     To load the image
//
//     #1. Check image is avaialble in cache or not.
//     A. If not Download the image from URL and save in cache.
//     B. If the image is avaible in cache then direct pass the image to imageview.
//
//
//     - parameters:
//      - urlString: The urlString in the Image URL, cannot be empty
//
// */
//    func loadImageUsingCacheUrlString(urlString: String)
//    {
//        self.image = UIImage(named: "defaultGallery.png")
//
//        let urlStr = urlString.replacingOccurrences(of: " ", with: "%20")
//
//        //Check cache for image first
//        if let cachedImage = imageCache.object(forKey: urlStr as NSString)
//        {
//            self.image = cachedImage
//            return
//        }
//        let url = NSURL(string: urlStr)
//        if url is URL
//        {
//            URLSession.shared.dataTask(with: url! as URL){
//                data,response,error  in
//
//                if error != nil
//                {
//                    #if DEDEBUG
//                    print("fail to download Image from FB with error: \(error?.localizedDescription)")
//                    #endif
//                    return
//                }
//                DispatchQueue.main.async {
//
//                    if let downloadedImage = UIImage(data: data!)
//                    {
//                        imageCache.setObject(downloadedImage, forKey: urlStr as NSString)
//                        self.image = downloadedImage
//                    }
//                   }
//                }.resume()
//        }
//    }
//}

//extension Date {
//    func dayNumberOfWeek() -> Int? {
//        return Calendar.current.dateComponents([.weekday], from: self).weekday
//    }
//    var dayValue: Int
//    {
//        return Calendar.current.component(.day, from: self)
//    }
//    var monthNumber:Int
//    {
//        return Calendar.current.component(.month, from: self)
//    }
//    var presentYear : Int
//    {
//        return Calendar.current.component(.year, from: self)
//    }
//    //    var dayMonthYear: (Int, Int, Int) {
//    //            let components = NSCalendar.currentCalendar.components([.day, .month, .year], fromDate: self)
//    //            return (components.day, components.month, components.year)
//    //        }
//    var presentHour: Int
//    {
//        var calender = Calendar(identifier: .gregorian)
//        calender.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//        return calender.component(.hour, from: self) //Calendar.current.component(.hour, from: self)
//    }
//    var presentMinute: Int
//    {
//        var calender = Calendar(identifier: .gregorian)
//        calender.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//        return calender.component(.minute, from: self)
//    }
//    var presentSecond: Int
//    {
//        var calender = Calendar(identifier: .gregorian)
//        calender.timeZone = NSTimeZone(name: "UTC")! as TimeZone
//        return calender.component(.second, from: self)
//    }
//    func timeAgoDisplay() -> String
//    {
//        let secondsAgo = Int(Date().timeIntervalSince(self))
//        let minute = 60
//        let hour = 60 * minute
//        let day = 24 * hour
//        let week = 7 * day
//        let month = 4 * week
//        let year = 12 * month
//        if secondsAgo > 0
//        {
//            if secondsAgo < minute
//            {
//                return "\(secondsAgo) seconds Ago"
//            }else if secondsAgo < hour
//            {
//                return "\(secondsAgo / minute) mintues Ago"
//            }else if secondsAgo < day
//            {
//                return "\(secondsAgo / hour) hours Ago"
//            }else if secondsAgo < week
//            {
//                return "\(secondsAgo / day) days Ago"
//            }else if secondsAgo < month
//            {
//                return "\(secondsAgo / week) weeks Ago"
//            }else if secondsAgo < year
//            {
//                return "\(secondsAgo / month) Months Ago"
//            }
//        }else
//        {
//            let absoluteValue = abs(secondsAgo)
//            if absoluteValue < minute
//            {
//                return "\(absoluteValue) seconds Later"
//            }else if absoluteValue < hour
//            {
//                return "\(absoluteValue / minute) mintues Later"
//            }else if absoluteValue < day
//            {
//                return "\(absoluteValue / hour) hours Later"
//            }else if absoluteValue < week
//            {
//                return "\(absoluteValue / day) days Later"
//            }else if absoluteValue < month
//            {
//                return "\(absoluteValue / week) weeks Later"
//            }else if absoluteValue < year
//            {
//                return "\(absoluteValue / month) Months Later"
//            }
//        }
//
//
//        return "\(secondsAgo / year) Years Ago"
//    }
//
//    func getElapsedInterval() -> String {
//
//        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
//
//        if let year = interval.year, year > 0 {
//
//            if let month = interval.month, month > 0 {
//                return (year == 1 ? "\(year)" + " " + "year and " :
//                    "\(year)" + " " + "years and ") + (month == 1 ? "\(month)" + " " + "month ago" :
//                    "\(month)" + " " + "months ago")
//            }
//            else {
//                return year == 1 ? "\(year)" + " " + "year ago" :
//                    "\(year)" + " " + "years ago"
//            }
//
//        } else if let month = interval.month, month > 0 {
//            return month == 1 ? "\(month)" + " " + "month ago" :
//                "\(month)" + " " + "months ago"
//        } else if let day = interval.day, day > 0 {
//            return day == 1 ? "\(day)" + " " + "day ago" :
//                "\(day)" + " " + "days ago"
//        } else {
//            return "a moment ago"
//
//        }
//
//    }
//
//}

//extension Array
//{
//    mutating func rearrange(from: Int, to: Int) {
//        if from == to
//        {
//            return
//        }
//        precondition(from != to && indices.contains(from) && indices.contains(to), "invalid indexes")
//        insert(remove(at: from), at: to)
//    }
//}

//extension String
//{
//    func isValidEmail() -> Bool
//    {
//        if self.count == 0 {
//
//            return false
//        }
//
//        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
//        
//        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//
//        return emailTest.evaluate(with: self)
//    }
//    var base64String: String
//    {
//        return Data(self.utf8).base64EncodedString()
//    }
//    func currencyFormate( _ price: Any) -> String
//    {
//        if let price = price as? NSNumber
//        {
//            return currencyFormate(price)
//        }
//        return ""
//    }
//    static func currencyFormate(_ price: Int32) -> String
//    {
//        let price = price as NSNumber
//        return currencyFormate(price)
//    }
//    static func currencyFormate(_ price: NSNumber) -> String
//    {
//
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        let locale = Locale(identifier: "en_AU")
//        formatter.locale = locale
//        //        formatter.formatWidth = 7
//        //        formatter.paddingPosition = .afterPrefix
//        //        formatter.paddingCharacter = " "
//        if let symbol = formatter
//            .currencySymbol
//        {
//            formatter.currencySymbol = "\(symbol) "
//        }
//
//        return (formatter.string(from: price)?.replacingOccurrences(of: ".00", with: ""))! //formatter.string(for: price)!.replacingOccurrences(of: ".00", with: "")
//    }
//    func currencyFormateWithoutSymbol(_ price: Int32) -> String
//    {
//        let valueString = currencyFormate(price)
//        return valueString.replacingOccurrences(of: "$", with: "")
//    }
//    func stringToDateConverter() -> Date?
//    {
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"
//
//        #if DEDEBUG
//        print(self)
//        #endif
//
//        if self != "" {
//
//            if self.contains("00:00:00") {
//                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//                #if DEDEBUG
//                print("exists Date format: 00:00:00")
//                #endif
//            }
//
//            if !self.contains(".") {
//                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//                #if DEDEBUG
//                print("exists Date format: 00:00:00")
//                #endif
//            }
//            else {
//                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//                dateFormater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
//
////                let splitArray = self.split(separator: ".")
////
////                if splitArray[1].count == 3 {
////                    dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"
////                }
////                else if splitArray[1].count == 2 {
////                    dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zz"
////                }
////                else if splitArray[1].count == 1 {
////                    dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.z"
////                }
//            }
//        }
//
//        var date = Date()
//
//        if self != "" {
//            if self.contains(".") {
//                let splitArray = self.split(separator: ".")
//                print(String(splitArray[0]))
//                date = dateFormater.date(from: String(splitArray[0]))!
//                print("++++++++++++\(String(describing: date))")
//            }
//            else {
//                date = dateFormater.date(from: self)!
//            }
//        }
//
//
//
//        return date
//    }
//    func stringToDateConverterForProgress() -> Date?
//    {
//        let dateFormater = DateFormatter()
//        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        let date = dateFormater.date(from: self)
//        return date
//    }
//    func displayDateFormateString() -> String
//    {
//        guard let presentDate = self.stringToDateConverter() else {return ""}
//
//        let date = presentDate.dayValue
//        let monthID = presentDate.monthNumber
//        let monthName = getMonthNameWith(id: monthID)
//        let year = presentDate.presentYear
//        return "\(date) \(monthName) \(year)"
//    }
//    func displayInTimeFormat() -> String
//    {
//        guard let presentDate = self.stringToDateConverter() else {return ""}
//        let presentHour = presentDate.presentHour
//        let timePeriod = presentHour > 12 ? "PM" : "AM"
//        let presentHourString = presentHour > 12 ? String(format:"%02d",presentHour - 12) : String(format:"%02d",presentHour)
//        let presenMinString = String(format:"%02d",presentDate.presentMinute)
//        let presentSecString = String(format:"%02d",presentDate.presentSecond)
//        return "\(presentHourString):\(presenMinString):\(presentSecString) \(timePeriod)"
//    }
//
//    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//
//        return ceil(boundingBox.height)
//    }
//
//    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
//        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
//        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
//
//        return ceil(boundingBox.width)
//    }
//
//    func heightForView(font: UIFont, width:CGFloat) -> CGFloat{
//        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
//        label.numberOfLines = 0
//        label.lineBreakMode = NSLineBreakMode.byWordWrapping
//        label.font = font
//        label.text = self
//        label.sizeToFit()
//        return label.frame.height
//    }
//    func rectForText(font: UIFont, maxSize: CGSize) -> CGFloat {
//        let attrString = NSAttributedString.init(string: self, attributes: [NSAttributedString.Key.font:font])
//        let constraintRect = CGSize(width: maxSize.width, height: .greatestFiniteMagnitude)
//        let rect = attrString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
//        let size = CGSize(width: rect.size.width, height: rect.size.height)
//        return size.height
//    }
//}


