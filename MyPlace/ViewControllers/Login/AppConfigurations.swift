//
//  AppConfigurations.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 02/11/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation


let appConfigKey = "AppConfigurations"


class AppConfigurations: NSObject {
 
    
    static let shared = AppConfigurations ()
    
    
    override init() {
        super.init()
    }
    
    
    func getAppConfigurations () {
    
        getAppConfigurationsService { (configs) in
            self.saveAppConfigurationstoDefaults(configurations: configs)
        }
    }
    
    func saveAppConfigurationstoDefaults (configurations: [NSDictionary]) {
        
        kUserDefaults.setValue(configurations, forKey: appConfigKey)
        kUserDefaults.synchronize()
        
        
        DispatchQueue.global(qos: .userInteractive).async {
            
        }
        
    }
    
    
    func getHowDoesitWorkURL () -> String? {
        
        return self.howDoesItWorkURLwith(contentName: "URL1")
    }
    
    func getHowDoesitWorkURLinMyCollection () -> String? {
        
        return self.howDoesItWorkURLwith(contentName: "URL2")
    }
    
    func getHowDoesitWorkURLinHomeandLand () -> String? {
        
        return self.howDoesItWorkURLwith(contentName: "URL3")
    }
    
    
    private func howDoesItWorkURLwith (contentName: String) -> String? {
        
        var howDoesitWorkURL: String? = nil
        
        if let appConfigs = kUserDefaults.value(forKey: appConfigKey) as? [NSDictionary] {
            
            for dict in appConfigs {
                if ((dict.value(forKey: "ContentName") as? String) ?? "") == contentName {
                    if String.checkNullValue (dict.value(forKey: "GroupName") as Any) == "HowDoesItWork", (dict["isActive"] as? NSNumber ?? 0).boolValue == true, let url = dict.value(forKey: "ContentValue") as? String {
                        if url.count > 0 {
                            
                            howDoesitWorkURL = url
                            break
                        }
                    }
                }
            }
        }
        
        return howDoesitWorkURL
    }
    
    
    
    
    //MARK: - API
    
    func getAppConfigurationsService (_ handler: @escaping ((_ configurationsArray: [NSDictionary]) -> Void)) {
                
        _ = Networking.shared.GET_request(url: ServiceAPI.shared.URL_config, userInfo: nil, success: { (json, response) in
            
            if let serviceResponse: AnyObject = json {
                
                if let result = serviceResponse as? [NSDictionary] {

                    if result.count > 0 {
                        handler (result)
                    }
                }
            }else {
                
            }
            
        }, errorblock: { (error, isJsonError) in
            
            if isJsonError { }
            else { }
            
        }, progress: nil)
    }
    
    
}
