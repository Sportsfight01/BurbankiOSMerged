//
//  MyPlace.swift
//  BurbankApp
//
//  Created by dmss on 24/10/17.
//  Copyright © 2017 DMSS. All rights reserved.
//

import Foundation

class MyPlaceStatusDetails
{
    var constructionID:String
    var officeID: String
    var jobNumber: String
    var region: String
    init(dic:[String: Any])
    {
        constructionID = dic["ConstructionID"] as? String ?? ""
        officeID = dic["OfficeID"] as? String ?? ""
        jobNumber = dic["JobNumber"] as? String ?? ""
        region = dic["Region"] as? String ?? ""
    }
}
class MyPlaceProgressDetailsVIC
{
    var id:Int
    var name: String
    var contractId: Int
    var stageName: String
    var dateCompleted: String
    
    init(dic: [String: Any])
    {
        id = dic["Id"] as? Int ?? 0
        contractId = dic["ContractId"] as? Int ?? 0
        name = dic["ItemName"] as? String ?? ""
        dateCompleted = dic["DateCompleted"] as? String ?? ""
        stageName = dic["StageName"] as? String ?? ""

    }
    
}


class MyPlaceProgressDetails
{
    var taskid:Int
    var resourcename: String
    var phasecode: String
    var sequence: Int
    var name: String
    var status: String
    var dateDescription: String
    var dateActual: String
//    var dateConvertMonthString:String
    var comment: String
    var forClient: Bool
    var stageID: Int
    var stageName: String

    init(dic: [String: Any])
    {
        taskid = dic["taskid"] as? Int ?? 0
        resourcename = dic["resourcename"] as? String ?? ""
        phasecode = dic["phasecode"] as? String ?? ""
        sequence = dic["sequence"] as? Int ?? 0
        name = dic["name"] as? String ?? ""
        status = dic["status"] as? String ?? ""
        dateDescription = dic["datedescription"] as? String ?? ""
        dateActual = dic["dateactual"] as? String ?? ""
        
//        if dateActual.count != 0 {
//            let dateFormatObj = DateFormatter()
//            dateFormatObj.dateFormat = "dd MMM yyyy"
//            
//            let dateObj = dateActual.stringToDateConverter()
//            
//            dateConvertMonthString = dateFormatObj.string(from: dateObj!) //dic["dateactual"] as? String ?? ""
//        }
//        else {
//            dateConvertMonthString = ""
//        }
        
        
        
        
        comment = dic["comment"] as? String ?? ""
        forClient = dic["forclient"] as? Bool ?? false
        stageID = dic["stageId"] as? Int ?? 0
        stageName = dic["stageName"] as? String ?? ""
    }
}
class MyPlaceContractDetails
{
    var id: Int
    var job: String
    var surName: String
  //  var clinetTitle: String
  //  var contactName: String
  //  var contactPhone: String
  //  var contactEmail: String
  //  var contactAgent: String
    var facadeStyle: String
    var jobStatus: String
    var contractValue: Int
    var supervisor: String
    var siteStartDate: String
    var contactEmail: String
    var jobAddress: String
    var houseType: String
    var homeCoOrdinator: String
    init(_ dic: [String: Any])
    {
        id = dic["id"] as? Int ?? 0
        job = dic["job"] as? String ?? ""
        surName = dic["surname"] as? String ?? ""
        facadeStyle = dic["facade"] as? String ?? ""
        jobStatus = dic["jobstatus"] as? String ?? ""
        contractValue = dic["contractvalue"] as? Int ?? 0
        supervisor = dic["supervisor"] as? String ?? ""
        siteStartDate = dic["sitestartdate"] as? String ?? ""
        contactEmail = dic["contactemail"] as? String ?? ""
        jobAddress = (dic["lotaddress"] as? String ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        houseType = dic["housetype"] as? String ?? ""
        homeCoOrdinator = (dic["clientliaison"] as? String ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}

class MyPlaceDocuments
{
    var authorName: String
    var byClient: Int
    var current: Int
    var docDate:String
    var title: String
    var type: String
    var urlId: Int
    var url:String
    init(_ dic:[String: Any])
    {
        authorName = dic["authorname"] as? String ?? ""
        byClient = dic["byclient"] as? Int ?? -1
        current = dic["current"] as? Int ?? -1
        docDate = dic["docdate"] as? String ?? ""
        title = dic["title"] as? String ?? ""
        type = (dic["type"] as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let urlIdTemp = (dic["url"] as? String ?? "").components(separatedBy: "?")[0].components(separatedBy: "/").last!
        url = dic["url"] as? String ?? ""
        urlId = Int(urlIdTemp)!
    }
}

class YearMonthList
{
    var yearMonth:Int
    var list : [DayWisePhotoList<MyPlaceDocuments>]
    init(yearMonth:Int,list:[DayWisePhotoList<MyPlaceDocuments>])
    {
        self.yearMonth = yearMonth
        self.list = list
    }
}
class YearMonthListNewFlow
{
    var yearMonth:Int
    var list : [DayWisePhotoList<DocumentsDetailsStruct>]
    init(yearMonth:Int,list:[DayWisePhotoList<DocumentsDetailsStruct>])
    {
        self.yearMonth = yearMonth
        self.list = list
    }
}
class DayWisePhotoList<T>
{
    var day: Int
    var list:[T]
    var yyyymmddString: String
    init(_ day: Int,_ list:[T], _ yyyymmddString: String = "")
    {
        self.day = day
        self.list = list
        
        #if DEDEBUG
       // print(yyyymmddString)
        #endif
        
        if !(yyyymmddString.contains(".")) {
            
            #if DEDEBUG
           // print("not exists")
            #endif
            
            self.yyyymmddString = yyyymmddString + ".00"
        }
        else {
            self.yyyymmddString = yyyymmddString
        }
    }
}

//for Contacts
class JobContacts
{
    var siteSupervisor: String
    var siteSupervisorEmail: String
    var siteSupervisorPhone: String
    
    var cro: String
    var croEmail: String
    var croPhone: String
    
    var salesConsultant: String
    var salesConsultantEmail: String
    var salesConsultantPhone: String

    var colourConsultant: String
    var colourConsultantEmail: String
    var colourConsultantPhone: String

    var electicalConsultant: String
    var electicalConsultantEmail: String
    var electicalConsultantPhone: String

    var staffManager: String
    var staffManagerEmail:String = ""
    var staffManagerPhone:String = ""

    
    
    
    init(_ dic:[String: Any])
    {
        siteSupervisor = dic["siteSupervisor"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        siteSupervisorEmail = dic["SiteSupervisorEmail"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        siteSupervisorPhone = dic["SiteSupervisorPhone"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        cro = dic["CRO"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        croEmail = dic["CROEmail"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        croPhone = dic["CROPhone"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        salesConsultant = dic["interiorDesigner"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        salesConsultantEmail = dic["InteriorDesignerEmail"] as? String ?? "--".trimmingCharacters(in: .whitespacesAndNewlines)
        salesConsultantPhone = dic["InteriorDesignerPhone"] as? String ?? "--".trimmingCharacters(in: .whitespacesAndNewlines)

        electicalConsultant = dic["electricalConsultant"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        electicalConsultantEmail = dic["ElectricalConsultantEmail"] as? String ?? "--".trimmingCharacters(in: .whitespacesAndNewlines)
        electicalConsultantPhone = dic["ElectricalConsultantPhone"] as? String ?? "--".trimmingCharacters(in: .whitespacesAndNewlines)
        
        colourConsultant = dic["newHomeConsultant"] as? String ?? "--".trimmingCharacters(in: .whitespacesAndNewlines)
        colourConsultantEmail = dic["NewHomeConsultantEmail"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        colourConsultantPhone = dic["NewHomeConsultantPhone"] as? String ?? "--".trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        

        staffManager = dic["staffManager"] as? String ?? "--".trimmingCharacters(in: .whitespacesAndNewlines)
        //staffManagerEmail = dic["staffManager"] as? String ?? "".trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
