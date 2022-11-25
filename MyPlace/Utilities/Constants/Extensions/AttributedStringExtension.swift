//
//  AttributedStringExtension.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 25/01/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import Foundation

//extension NSMutableAttributedString
//{
//enum scripting : Int
//{
//    case aSub = -1
//    case aSuper = 1
//}
//
//func characterSubscriptAndSuperscript(string:String,
//                                      characters:[Character],
//                                      type:scripting,
//                                      fontSize:CGFloat,
//                                      scriptFontSize:CGFloat,
//                                      offSet:Int,
//                                      length:[Int],
//                                      alignment:NSTextAlignment)-> NSMutableAttributedString
//{
//    let paraghraphStyle = NSMutableParagraphStyle()
//     // Set The Paragraph aligmnet , you can ignore this part and delet off the function
//    paraghraphStyle.alignment = alignment
//
//    var scriptedCharaterLocation = Int()
//    //Define the fonts you want to use and sizes
//    let stringFont = UIFont.boldSystemFont(ofSize: fontSize)
//    let scriptFont = UIFont.boldSystemFont(ofSize: scriptFontSize)
//     // Define Attributes of the text body , this part can be removed of the function
//
//    let attString = NSMutableAttributedString(string: string, attributes: [.font: stringFont, .foregroundColor: UIColor.black, .paragraphStyle:paraghraphStyle])
//
////    let attString = NSMutableAttributedString(string:string, attributes: [NSFontAttributeName:stringFont,NSForegroundColorAttributeName:UIColor.black,NSParagraphStyleAttributeName: paraghraphStyle])
//
//    // the enum is used here declaring the required offset
//    let baseLineOffset = offSet * type.rawValue
//    // enumerated the main text characters using a for loop
//    for (i,c) in string.characters.enumerated()
//    {
//        // enumerated the array of first characters to subscript
//        for (theLength,aCharacter) in characters.enumerated()
//        {
//            if c == aCharacter
//            {
//               // Get to location of the first character
//                scriptedCharaterLocation = i
//              //Now set attributes starting from the character above
//               attString.setAttributes([NSFontAttributeName:scriptFont,
//              // baseline off set from . the enum i.e. +/- 1
//              NSBaselineOffsetAttributeName:baseLineOffset,
//              NSForegroundColorAttributeName:UIColor.black],
//               // the range from above location
//        range:NSRange(location:scriptedCharaterLocation,
//         // you define the length in the length array
//         // if subscripting at different location
//         // you need to define the length for each one
//         length:length[theLength]))
//
//            }
//        }
//    }
//    return attString}
//  }
//
//let attStr1 = NSMutableAttributedString().characterSubscriptAndSuperscript(
//               string: "23 x 456",
//               characters:["3","5"],
//               type: .aSuper,
//               fontSize: 20,
//               scriptFontSize: 15,
//               offSet: 10,
//               length: [1,2],
//               alignment: .left)

//let font:UIFont? = UIFont(name: "Helvetica", size:20)
//let fontSuper:UIFont? = UIFont(name: "Helvetica", size:10)
//let attString:NSMutableAttributedString = NSMutableAttributedString(string: "6.022*1023", attributes: [.font:font!])
//attString.setAttributes([.font:fontSuper!,.baselineOffset:10], range: NSRange(location:8,length:2))
//labelVarName.attributedText = attString
