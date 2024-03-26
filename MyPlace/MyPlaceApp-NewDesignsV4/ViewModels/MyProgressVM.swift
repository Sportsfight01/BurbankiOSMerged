//
//  MyProgressVM.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 13/07/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import Foundation
import Combine
class MyProgressVM
{
    //MARK: - Properties
    var progressData : [ProgressStruct]?
    private(set) var financeVisibilityPublisher = PassthroughSubject<Bool,Never>()
    
    //MARK: - Helper Methods
    
    private func checkForFinanceVisibility(adminData : [ProgressStruct]?)
    {
        guard let adminData else { return }
        let contracts = ["Sign Building Contract", "Contract Signed"].map({$0.trim().lc})
        let isFinanceVisible = !adminData.filter({
            (contracts.contains($0.name?.trim().lc ?? "") == true) &&
            ($0.status?.trim().lc.contains("completed") == true)
        }).isEmpty
        financeVisibilityPublisher.send(isFinanceVisible)
    }
    
    //MARK: - ServiceCalls
    func getProgressDataV3(completion : @escaping(Result<[ProgressItem],Error>)->()){
        APIManager.shared.getProgressV3{ [weak self] result in
            guard let self else { return }
            switch result
            {
            case .success(let progressData) :
                print(log: progressData)
                self.progressData = progressData
                /// - Grouping the data with stages in Dictionary
                let stageGroup = self.groupProgressDataWithStage()
                /// - Transforming data for display
                let sortedItems = self.transformStageGroup(stageGroup: stageGroup)
                
                completion(.success(sortedItems))
                
            case .failure(let err):
                print(log: "failed")
                completion(.failure(err))
            }
            
        }
    }
    
    
    
//    func getProgressData(completion : @escaping(Result<[ProgressItem],Error>)->())
//    {
//        APIManager.shared.getProgressDetails {[weak self] result in
//            guard let self else { return }
//            switch result
//            {
//            case .success(let progressData):
//                self.progressData = progressData
//                /// - Grouping the data with stages in Dictionary
//                let stageGroup = self.groupProgressDataWithStage()
//                /// - Transforming data for display
//                let sortedItems = self.transformStageGroup(stageGroup: stageGroup)
//                
//                completion(.success(sortedItems))
//                
//            case .failure(let err):
//                completion(.failure(err))
//            }
//            
//        }
//    }
    private func groupProgressDataWithStage() -> Dictionary<String,[ProgressStruct]>
    {
        guard let progressData else { return [:] }
        let stageGroup = Dictionary(grouping: progressData) { item in
            let phacecode = item.phasecode?.trim().lc
            /// - Taking presite stage name for all precontract construction data
            
            if phacecode == "presite" { return "Admin Stage" }
            
            let stageName = item.stageName?.trim().lc
            switch stageName
            {
                /// - completion and handover are taking as finishing stage
                /// removing "All Stages" and "Administration" from contact construction data
            case "completion","handover" : return "Finishing Stage"
            case "fixout stage" : return "Fixing Stage"
            default:
                return item.stageName?.capitalized ?? "none"
            }
        }
        debugPrint("all keys : \(stageGroup.keys)")
        self.checkForFinanceVisibility(adminData: stageGroup["Admin Stage"])
        return stageGroup
    }
    /// - transforming stageGroup to required ProgressItem Array to display data conveniently on MyProgressVC
    private func transformStageGroup(stageGroup : [String : [ProgressStruct]]) -> [ProgressItem]
    {
        let clItems = stageGroup.map { (key: String, value: [ProgressStruct]) in
            let completedTasksCount = value.filter({$0.status == "Completed"}).count //completed tasks
            let totalTasks = value.count // total records in stage
            let progress =  Double(completedTasksCount )/Double(totalTasks) // progress of stage
            let stage = Stage(rawValue: key)
            let clItem = ProgressItem(stage: stage,
                                      imageName: stage?.icon ?? "",
                                      progress: progress,
                                      progressDetails: value,
                                      detailText: stage?.detailedText)
            return clItem
        }
        let sortedItems = clItems.sorted(by: {$0.stage?.order ?? 0 < $1.stage?.order ?? 0})
        return sortedItems
        
    }
    
    struct ProgressItem
    {
        let stage : Stage?
        let imageName : String
        var progress : CGFloat?
        var progressDetails : [ProgressStruct]?
        var detailText : String?
    }
    
}

 //MARK: - Static Stage Data
enum Stage : String
{
    case admin       = "Admin Stage"
    case base        = "Base Stage"
    case frame       = "Frame Stage"
    case lockup      = "Lockup Stage"
    case fixing      = "Fixing Stage"
    case finishing   = "Finishing Stage"
    case yourNewHome = "Your New Home"
//    case allStages   = "All Stages"
//    case handover    = "Handover"
    
    
    var order : Int
    {
        switch self
        {
        case .admin:
            return 1
        case .base:
            return 2
        case .frame:
            return 3
        case .lockup:
            return 4
        case .fixing:
            return 5
        case .finishing:
            return 6
//        case .allStages:
//            return 7
//        case .handover:
//            return 8
        default:// Your New Home
            return 0
        }
        
    }
    var icon : String
    {
        switch self
        {
        case .admin:
            return "icon_Details_Dark"
        case .base:
            return "icon_Base"
        case .frame:
            return "icon_Frame"
        case .lockup:
            return "icon_Lockup"
        case .fixing:
            return "icon_Fixout"
        case .finishing:
            return "icon_Complete"
//        case .allStages:
//            return "icon_house"
//        case .handover:
//            return "icon_house"
        default: // your new home
            return "icon_house"
        }
    }
    var detailedText : String
    {
        switch self{
            
        case .admin:
            return "We’re gathering the paperwork ready for approvals."
        case .base:
            return "We will pour the foundation for your new home."
        case .frame:
            return "The frame forms the skeleton of your new home."
        case .lockup:
            return "Your home will now be prepared for locking up."
        case .fixing:
            return "All the internal design features will now be fitted into your home."
        case .finishing:
            return "As the name suggests, we’re almost there."
//        case .allStages:
//            return "As the name suggests, we’re almost there."
//        case .handover:
//            return "As the name suggests, we’re almost there."
        default: // your new home
            return "We're now on the way to building your new home. All you have to do is swipe to see your build progress."
        }
    }
    var progressColor : UIColor
    {
        switch self
        {
        case .admin:
            return AppColors.StageColors.admin
        case .base:
            return AppColors.StageColors.base
        case .frame:
            return AppColors.StageColors.frame
        case .lockup:
            return AppColors.StageColors.lockup
        case .fixing:
            return AppColors.StageColors.fixing
        case .finishing:
            return AppColors.StageColors.finishing
//        case .handover:
//            return AppColors.StageColors.admin
//        case .allStages:
//            return AppColors.StageColors.frame
        default: // your new home
            return APPCOLORS_3.Orange_BG
        }
    }
}
/// - Structs


// MARK: - ProgressStruct
struct ProgressStruct: Codable, Equatable {
    let taskid: Int?
    let resourcename, phasecode: String?
    let sequence: Int?
    let name, status, datedescription, dateactual: String?
    let comment: String?
    let forclient: Bool?
    let stageID: Int?
    let stageName: String?
    
    enum CodingKeys: String, CodingKey {
        case taskid, resourcename, phasecode, sequence, name, status, datedescription, dateactual, comment, forclient
        case stageID = "stageId"
        case stageName
    }
    var date : Date {
        return dateactual?.components(separatedBy: ".").first?.getDate() ?? Date()
    }
    var dateWithoutTime : Date
    {
        return dateactual?.components(separatedBy: "T").first?.getDate("yyyy-MM-dd") ?? Date()
    }
}
