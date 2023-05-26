//
//  StringExtension.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 01/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation
import ValidationComponents
extension String {
    
    var floatValue: Float {
        
        return (self as NSString).floatValue
    }
    
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options:
            .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with:
                "", options:.regularExpression, range: nil)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    func htmlAttributed(family: String? = "Montserrat", size: CGFloat = 12.0, color: UIColor = .black) -> NSAttributedString? {
          do {
              let htmlCSSString = "<style>" +
                  "html *" +
                  "{" +
                  "font-size: \(size)pt !important;" +
                  "font-family: \(family ?? "Montserrat"), Montserrat !important;" +
              "}</style> \(self)"

              guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                  return nil
              }

              return try NSAttributedString(data: data,
                                            options: [.documentType: NSAttributedString.DocumentType.html,
                                                      .characterEncoding: String.Encoding.utf8.rawValue],
                                            documentAttributes: nil)
          } catch {
              print("error: ", error)
              return nil
          }
      }
    var decodeEmoji: String {
        
        let data = self.data(using: String.Encoding.utf8);
        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        
        if let str = decodedStr {
            return str as String
        }
        return self.trim()
    }
    
    var encodeEmoji: String {
        
        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        {
            return encodeStr as String
        }
        return self.trim()
    }
    
    var base64String: String
    {
        return Data(self.utf8).base64EncodedString()
    }

    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    //    func isValidEmail() -> Bool {
    //
    //        if self.count == 0 { return false }
    //
    //        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    //        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    //        return emailPred.evaluate(with: self)
    //    }
    
    func whiteSpacesRemoved() -> String {
      return self.filter { $0 != Character(" ") }
    }
    
    
    func emojiToImage(size: CGSize) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)//*22*84536#
        UIColor.white.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(rect)
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }
    
    func extractAll(type: NSTextCheckingResult.CheckingType) -> [NSTextCheckingResult] {
        var result = [NSTextCheckingResult]()
        do {
            let detector = try NSDataDetector(types: type.rawValue)
            result = detector.matches(in: self, range: NSRange(startIndex..., in: self))
        } catch { print("ERROR: \(error)") }
        return result
    }
    
    func to(type: NSTextCheckingResult.CheckingType) -> String? {
        let phones = extractAll(type: type).compactMap { $0.phoneNumber }
        switch phones.count {
        case 0: return nil
        case 1: return phones.first
        default: print("ERROR: Detected several phone numbers"); return nil
        }
    }
    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter{CharacterSet.decimalDigits.contains($0)}
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }
    func makeAColl() {
        guard   let number = to(type: .phoneNumber),
            let url = URL(string: "tel://\(number.onlyDigits())"),
            UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func isValidEmail() -> Bool
    {
        if self.count == 0 {
            
            return false
        }
        //let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
      //  let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
       /// let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let rule = EmailValidationPredicate()
        let isValidEmail = rule.evaluate(with: self)
        return isValidEmail
    }
    func currencyFormate( _ price: Any) -> String
    {
        if let price = price as? NSNumber
        {
            return currencyFormate(price)
        }
        return ""
    }
    static func currencyFormate(_ price: Int32) -> String
    {
        let price = price as NSNumber
        return currencyFormate(price)
    }
    static func currencyFormate(_ price: NSNumber) -> String
    {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let locale = Locale(identifier: "en_AU")
        formatter.locale = locale
        //        formatter.formatWidth = 7
        //        formatter.paddingPosition = .afterPrefix
        //        formatter.paddingCharacter = " "
        if let symbol = formatter.currencySymbol {
            
            formatter.currencySymbol = "\(symbol)"
        }
        
        return (formatter.string(from: price)?.replacingOccurrences(of: ".00", with: ""))!.whiteSpacesRemoved() //formatter.string(for: price)!.replacingOccurrences(of: ".00", with: "")
    }
    
    static func currencyFormateWithoutSymbol(_ price: Int32) -> String
    {
        let valueString = currencyFormate(price)
        return valueString.replacingOccurrences(of: "$", with: "")
    }
    func stringToDateConverter() -> Date?
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"
        
        #if DEDEBUG
       // print(self)
        #endif
        
        if self != "" {
            
            if self.contains("00:00:00") {
                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                #if DEDEBUG
               // print("exists Date format: 00:00:00")
                #endif
            }
            
            if !self.contains(".") {
                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                #if DEDEBUG
               // print("exists Date format: 00:00:00")
                #endif
            }
            else {
                dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                dateFormater.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss"
                
                //                let splitArray = self.split(separator: ".")
                //
                //                if splitArray[1].count == 3 {
                //                    dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"
                //                }
                //                else if splitArray[1].count == 2 {
                //                    dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zz"
                //                }
                //                else if splitArray[1].count == 1 {
                //                    dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.z"
                //                }
            }
        }
        
        var date = Date()
        
        if self != ""{
            if self.contains(".") {
                let splitArray = self.split(separator: ".")
                //print(String(splitArray[0]))
                date = dateFormater.date(from: String(splitArray[0]))!
               // print("++++++++++++\(String(describing: date))")
            }
            else {
                if self != "- -"{
                    date = dateFormater.date(from: self)!
                }
                
            }
        }
        
        
        
        return date
    }
    
    func getDate(_ dateFormat : String = "yyyy-MM-dd'T'HH:mm:ss") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self) // replace Date String
    }
    
    
    func stringToDateConverterForProgress() -> Date?
    {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormater.date(from: self)
        return date
    }
    func displayDateFormateString() -> String
    {
        guard let presentDate = self.stringToDateConverter() else {return ""}
        
        let date = presentDate.dayValue
        let monthID = presentDate.monthNumber
        let monthName = getMonthNameWith(id: monthID)
        let year = presentDate.presentYear
        return "\(date) \(monthName) \(year)"
    }
    func displayInTimeFormat() -> String
    {
        guard let presentDate = self.stringToDateConverter() else {return ""}
        let presentHour = presentDate.presentHour
        let timePeriod = presentHour > 12 ? "PM" : "AM"
        let presentHourString = presentHour > 12 ? String(format:"%02d",presentHour - 12) : String(format:"%02d",presentHour)
        let presenMinString = String(format:"%02d",presentDate.presentMinute)
        let presentSecString = String(format:"%02d",presentDate.presentSecond)
        return "\(presentHourString):\(presenMinString):\(presentSecString) \(timePeriod)"
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func heightForView(font: UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func rectForText(font: UIFont, maxSize: CGSize) -> CGFloat {
        let attrString = NSAttributedString.init(string: self, attributes: [NSAttributedString.Key.font:font])
        let constraintRect = CGSize(width: maxSize.width, height: .greatestFiniteMagnitude)
        let rect = attrString.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize(width: rect.size.width, height: rect.size.height)
        return size.height
    }
    
    func SizeOf(_ font: UIFont) -> CGSize {
        return self.size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
    func dataStringToImage() -> UIImage {
        if  let dataDecoded : Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            if let img = UIImage(data: dataDecoded) {
                return img
            }
        }
        return UIImage()

    }
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }

}

extension String {
    
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    static func formattedNumber(number: String) -> String {
        let cleanPhoneNumber = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let mask = "+X (XXX) XXX-XXXX"
        
        var result = ""
        var index = cleanPhoneNumber.startIndex
        for ch in mask where index < cleanPhoneNumber.endIndex {
            if ch == "X" {
                result.append(cleanPhoneNumber[index])
                index = cleanPhoneNumber.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    func priceUSAFormat() -> String {
        
        if let myInteger = Float(self) {
            let myNumber = NSNumber(value: myInteger)
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            return formatter.string(from: myNumber)!
        }
        
        return "$0.00"
    }
    
    static func checkNullValue(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        return (valueString as! String).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    
    static func checkNullValue_Dash(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = "-"
        }
        return (valueString as! String).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    static func checkNullValue_NA(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = "NA"
        }
        return (valueString as! String).trimmingCharacters(in: .whitespacesAndNewlines)
    }

    
    static func checkRatingValue(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = "New"
        }
        else {
            if (valueString as! CGFloat) == 0.0 {
                valueString = "New"
            }
            else {
                valueString = String(format: "%.1f", valueString as! CGFloat)
            }
        }
        return valueString as! String
    }
    
    static func checkNumberNull(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        else {
            valueString = String(format: "%d", valueString as! Int)
        }
        
        return valueString as! String
    }
    
    static func checkNSNumberNull(_ inputValue: Any) -> String {
        
//        print(inputValue)
        
        var valueString = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        else {
            valueString = String(valueString as! Int)
            
        }
        
        return valueString as! String
    }
    
    static func checkNumberNullWithID(_ inputValue: Any) -> Int {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = 0
        }
        else {
            
        }
        
        return valueString as! Int
    }
    
    
    static func checkFloatNull(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        else {
            
            if let someObj = valueString as? NSNumber {
                valueString = String(format: "%.2f", someObj.floatValue)
            }
            
        }
        
        return valueString as! String
    }
    
    static func checkDoubleNull(_ inputValue: Any) -> Double {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = 0.0
        }
        else {
//            valueString =  //String(format: "%.2f", valueString as! CGFloat)
        }
        
        return valueString as! Double
    }
    
    static func checkFloatLatLngNull(_ inputValue: Any) -> Float {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = 0.00000
        }
        
        return valueString as! Float
    }
    
    
    static func checkDateNull(_ dateValue: Any) -> String {
        var newDateValue: Any = dateValue
        if  (newDateValue as AnyObject).isEqual(NSNull()) {
            newDateValue = ""
        }
        else {
            
//            print(dateValue)
            
            let actualDateString = (newDateValue as! String).replacingOccurrences(of: "+00:00", with: "")
            
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM yyyy, h:mm a"
            var date = dateFormatter.date(from: actualDateString)
            
            // if .zzz format not coming from date format // then give only upto seconds format
            if date == nil {
                dateFormatter.dateFormat = "dd MMM yyyy, h:mm a"
                date = dateFormatter.date(from: actualDateString)
            }
            
            // if .ss format not coming from date format // then give only upto milli seconds format
            if date == nil {
                dateFormatter.dateFormat = "dd MMM yyyy, h:mm a"
                date = dateFormatter.date(from: actualDateString)
            }
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
            dateFormatter.timeZone = NSTimeZone.local
            let timeStamp = dateFormatter.string(from: date!)
//            print(timeStamp)
            
            return timeStamp
            
        }
        return newDateValue as! String
    }
    
    static func checkDateWithTimeNull(_ dateValue: Any) -> String {
        var newDateValue: Any = dateValue
        if  (newDateValue as AnyObject).isEqual(NSNull()) {
            newDateValue = ""
        }
        else {
            
            let actualDateString = (newDateValue as! String).replacingOccurrences(of: "+00:00", with: "")
            
            // create dateFormatter with UTC time format
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"
            var date = dateFormatter.date(from: actualDateString)
            
            if date == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                date = dateFormatter.date(from: actualDateString)
            }
            
            if date == nil {
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                date = dateFormatter.date(from: actualDateString)
            }
            
            // change to a readable time format and change to local time zone
            dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
            dateFormatter.timeZone = NSTimeZone.local
            let timeStamp = dateFormatter.string(from: date!)
//            print(timeStamp)
            
            return timeStamp
            
        }
        return newDateValue as! String
    }
    
    
    static func checkBoolNull(_ value : Any) -> Bool {
        
        var newBoolValue : Any = value
        
        if (newBoolValue as AnyObject).isEqual(NSNull()) {
            newBoolValue = false
        }
        else
        {
//            print(newBoolValue)
        }
        return newBoolValue as! Bool
    }
    
    static func checkArray(_ value : Any) -> NSArray {
        
        var newValue : Any = value
        
        if (newValue as AnyObject).isEqual(NSNull()) {
            newValue = NSArray()
        }
        else
        {
//            print(newValue)
        }
        return newValue as! NSArray
    }
    
    static func checkDictionary(_ value : Any) -> NSDictionary {
        
        var newValue : Any = value
        
        if (newValue as AnyObject).isEqual(NSNull()) {
            newValue = NSDictionary()
        }
        else
        {
//            print(newValue)
        }
        return newValue as! NSDictionary
    }
    
    static func checkNumberNullWithVotesText(_ inputValue: Any) -> String {
        
        var valueString : Any = inputValue
        
        if (valueString as AnyObject).isEqual(NSNull()) {
            valueString = ""
        }
        else {
            valueString = String(format: "%d", valueString as! Int)
        }
        
        var actualValue = valueString as! String
        
        if Int(actualValue) == 0 || Int(actualValue) == 1 {
            
            actualValue = String(format: "%@ Vote", actualValue)
        }
        else {
            actualValue = String(format: "%@ Votes", actualValue)
        }
        
        return actualValue
    }
    
}


extension String {
    var imageFromBase64: UIImage? {
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
