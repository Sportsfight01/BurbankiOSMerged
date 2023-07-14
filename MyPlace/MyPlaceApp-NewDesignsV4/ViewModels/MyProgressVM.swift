//
//  MyProgressVM.swift
//  BurbankApp
//
//  Created by Naresh Banavath on 13/07/23.
//  Copyright © 2023 Sreekanth tadi. All rights reserved.
//

import Foundation
class MyProgressVM
{
    func getProgressData()
    {
        APIManager.shared.getProgressDetails { progressData in            
            /// - Grouping the data with stages
            let stageGroup = Dictionary(grouping: progressData) { pr in
                if pr.phasecode == "Presite" { return "Admin Stage" }
                else if pr.stageName == "Completion" || pr.stageName == "Handover" { return "Finishing Stage"}
                else if pr.stageName == "Fixout Stage" { return "Fixing Stage" }
                return pr.stageName?.capitalized ?? "none"
            }
            /// - Transforming data for display
            let clItems = stageGroup.map { (key: String, value: [ProgressStruct]) in
                let completedTasksCount = value.filter({$0.status == "Completed"}).count //completed tasks
                let totalTasks = value.count // total records in stage
                let progress =  Double(completedTasksCount )/Double(totalTasks)
                let stage = Stage(rawValue: key)
                let clItem = ProgressItem(title: stage,
                                    imageName: stage?.icon ?? "",
                                    progress: progress,
                                    progressDetails: value,
                                    detailText: stage?.detailedText)
                return clItem
            }
            let sortedItems = clItems.sorted(by: {$0.title?.order ?? 0 < $1.title?.order ?? 0})
        }
    }
    struct ProgressItem
    {
        let title : Stage?
        let imageName : String
        var progress : CGFloat?
        var progressDetails : [ProgressStruct]?
        var detailText : String?
    }
    
}

 //MARK: - Static Stage Data
enum Stage : String
{
    case admin     = "Admin Stage"
    case base      = "Base Stage"
    case frame     = "Frame Stage"
    case lockup    = "Lockup Stage"
    case fixing    = "Fixing Stage"
    case finishing = "Finishing Stage"
    
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
        }
    }
}
