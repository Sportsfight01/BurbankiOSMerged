
import Foundation

//extension String {
//    
//    var floatValue: Float {
//        
//        return (self as NSString).floatValue
//    }
//    
//    var withoutHtmlTags: String {
//        return self.replacingOccurrences(of: "<[^>]+>", with: "", options:
//            .regularExpression, range: nil).replacingOccurrences(of: "&[^;]+;", with:
//                "", options:.regularExpression, range: nil)
//    }
//    
//    var htmlToAttributedString: NSAttributedString? {
//        guard let data = data(using: .utf8) else { return NSAttributedString() }
//        do {
//            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
//        } catch {
//            return NSAttributedString()
//        }
//    }
//    var htmlToString: String {
//        return htmlToAttributedString?.string ?? ""
//    }
//    
//    var decodeEmoji: String {
//        
//        let data = self.data(using: String.Encoding.utf8);
//        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
//        
//        if let str = decodedStr {
//            return str as String
//        }
//        return self.trim()
//    }
//    
//    var encodeEmoji: String {
//        
//        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
//        {
//            return encodeStr as String
//        }
//        return self.trim()
//    }
//   
////    func trim() -> String {
////        return self.trimmingCharacters(in: .whitespacesAndNewlines)
////    }
//
//
//}

@discardableResult
func setAttributetitleFor (view: UIView?, title: String, rangeStrings: [String], colors: [UIColor], fonts: [UIFont], alignmentCenter: Bool) -> NSMutableAttributedString {
    
    if rangeStrings.count != colors.count || rangeStrings.count != fonts.count {
        assertionFailure("setAttributetitleFor")
//        assert(true, "setAttributetitleFor")
//        abort()
    }
    
    let str = NSString(format: "%@", title)
    
    let attr = NSMutableAttributedString(string: str as String)
    
    for i in 0...rangeStrings.count-1 {
        let rangeStr = rangeStrings[i]
        let color = colors.count>i ? colors[i] : UIColor.black
        let font = fonts.count>i ? fonts[i] : regularFontWith(size: 12)
        
        attr.addAttributes([NSAttributedString.Key.foregroundColor: color, .font: font], range: str.range(of: rangeStr))
    }
    
    
    if let vie = view {
        if vie.isKind(of: UIButton.self) {
            (vie as! UIButton).setAttributedTitle(attr, for: .normal)
            (vie as! UIButton).titleLabel?.numberOfLines = title.components(separatedBy: "\n").count
            if alignmentCenter { (vie as! UIButton).titleLabel?.textAlignment = NSTextAlignment.center }
        }else {
            //label
            (vie as! UILabel).attributedText = attr
            if alignmentCenter { (vie as! UILabel).textAlignment = NSTextAlignment.center }
            if (vie as! UILabel).lineBreakMode != .byTruncatingTail { (vie as! UILabel).numberOfLines = title.components(separatedBy: "\n").count }
        }
        return attr
    }else {
        
        return attr
    }
    
}
extension String
{
    func toInt() -> Int
    {
        return Int(self) ?? 0
    }
    
    
}
