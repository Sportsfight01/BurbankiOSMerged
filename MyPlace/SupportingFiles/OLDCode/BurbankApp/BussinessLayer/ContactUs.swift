//
//  ContactUs.swift
//  BurbankApp
//
//  Created by Apple on 12/21/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import Foundation


//for ContactUsVIC
class ContactUsVIC
{
    var noteid: String
    var subject: String
    var authorname: String
    var notedate: String
    var notedateWithFormat: String
    var body: String
   
    init(_ dic:[String: Any])
    {
        noteid = dic["Id"] as? String ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        subject = dic["Description"] as? String ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        authorname = dic["AuthorName"] as? String ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        notedate = dic["DateCreated"] as? String ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        body = dic["Notes"] as? String ?? "".trimmingCharacters(in: .whitespacesAndNewlines)
       
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm:ss a"
        
        if let date = dateFormatterGet.date(from: notedate) {
            #if DEDEBUG
            print(dateFormatterPrint.string(from: date))
            #endif
            notedateWithFormat = dateFormatterPrint.string(from: date)
        } else {
            #if DEDEBUG
            print("There was an error decoding the string")
            #endif
            notedateWithFormat = ""
        }
        
    }
}


//for ContactUsQLDSA
class ContactUsQLDSA
{
    var noteid: String
    var subject: String
    var authorname: String
    var notedate: String
    var notedateWithFormat: String
    var body: String
    
    init(_ dic:[String: Any])
    {
        noteid = dic["noteId"] as? String ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        subject = dic["subject"] as? String ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        authorname = dic["authorname"] as? String ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        notedate = dic["notedate"] as? String ?? "".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        body = dic["body"] as? String ?? "".trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.zzz"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd/MM/yyyy HH:mm:ss a"
        
        if let date = dateFormatterGet.date(from: notedate) {
            #if DEDEBUG
            print(dateFormatterPrint.string(from: date))
            #endif
            notedateWithFormat = dateFormatterPrint.string(from: date)
        } else {
            #if DEDEBUG
            print("There was an error decoding the string")
            #endif
            notedateWithFormat = ""
        }
        
        
    }
}






