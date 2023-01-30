//
//  HomeDesign.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 14/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit


class HomeDesignFeature: NSObject {
    
    
    var featureName: String?
    var question: String?
    var questionOrder: NSNumber?
    
    var maxValue: Double?
    var minValue: Double?
    
    var answerOptions = [Answer] ()

    
    var selectedAnswer: String = ""
    var displayString: String = ""

    
    
    var selectedMinPrice: String = ""
    var selectedMaxPrice: String = ""
    
    
    
    override init() {
        super.init()
        
    }
    
    
    
    init(dict: NSDictionary) {
        super.init()
        
        featureName = String.checkNullValue (dict.value(forKey: "Feature") as Any)
        question = String.checkNullValue (dict.value(forKey: "Question") as Any)
        
        
        questionOrder = (dict.value (forKey: "QuestionOrder") as? NSNumber ?? 0)
        minValue = (dict.value (forKey: "MinValue") as? Double ?? 0.0)
        maxValue = (dict.value (forKey: "MaxValue") as? Double ?? 0.0)
        for option in dict.value(forKey: "Options") as! [String] {
            answerOptions.append(Answer (answer: String.checkNullValue (option as Any)))
        }
        answerOptions.append(Answer (answer: "NOT SURE"))
    }
    
    init(nextFeature: NSDictionary) {
        super.init()
        
        featureName = String.checkNullValue (nextFeature.value(forKey: "NextFeature") as Any)
        question = String.checkNullValue (nextFeature.value(forKey: "NextFeatureQuestion") as Any)
        
        
        questionOrder = (nextFeature.value (forKey: "QuestionOrder") as? NSNumber ?? 0)
        
        
        minValue = (nextFeature.value (forKey: "MinValue") as? Double ?? 0.0)
        maxValue = (nextFeature.value (forKey: "MaxValue") as? Double ?? 0.0)
        
        
        for option in nextFeature.value(forKey: "NextFeatureAnswers") as! [String] {
            
            answerOptions.append(Answer (answer: String.checkNullValue (option as Any)))
        }
        
        
        if featureName!.lowercased().contains("lot width") {
            answerOptions.sort { (ans1, ans2) -> Bool in
                return (ans1.displayAnswer as NSString).floatValue < (ans2.displayAnswer as NSString).floatValue
            }
        }
        answerOptions.append(Answer (answer: "NOT SURE"))
    }
        
    
    init(recentSearch: NSDictionary) {
        super.init()
        
        featureName = String.checkNullValue (recentSearch.value(forKey: "feature") as Any)
        question = String.checkNullValue (recentSearch.value(forKey: "question") as Any)
                
        
        if (recentSearch.allKeys as! [String]).contains("Answer"), String.checkNullValue (recentSearch.value(forKey: "Answer") ?? "").count > 0 {
            
            selectedAnswer = String.checkNullValue (recentSearch.value (forKey: "Answer") as Any)
            
            displayString = String.checkNullValue (recentSearch.value (forKey: "Answer") as Any)
            
            if featureName!.lowercased().contains("storey") {
                
                if selectedAnswer == "1" {
                    displayString = "SINGLE"
                }else if selectedAnswer == "2" {
                    displayString = "DOUBLE"
                }else if selectedAnswer == "3" {
                    displayString = "TRIPLE"
                }else {
                    displayString = "ALL"
                }
            }else if selectedAnswer == DesignAnswer.must.rawValue {
                
                displayString = featureName!.uppercased()
                if featureName!.lowercased().contains("living/meals") {
                    
                    displayString = featureName!.uppercased()
                }
            }else if selectedAnswer == DesignAnswer.dontmind.rawValue {
             
                displayString = "" //NO " + featureName!.uppercased()
            }else if selectedAnswer == DesignAnswer.donotwantthis.rawValue {
                
                displayString = "" //NO " + featureName!.uppercased()
            }else if featureName!.lowercased().contains("bedroom") {
                
                displayString = selectedAnswer + " BED"
            }else if featureName!.lowercased().contains("lot width") {
                
                let ans = Answer (answer: selectedAnswer)
                
                displayString = ans.addM()
            }else {
                
            }
            
        }else {
            
            if featureName!.lowercased().contains("lot width") {
                
                selectedAnswer = String.checkNullValue (recentSearch.value (forKey: "MaxValue") as Any)
                
                let ans = Answer (answer: selectedAnswer)
                
                displayString = ans.addM()
            }else {
                
                minValue = (recentSearch.value (forKey: "MinValue") as? Double ?? 0)
                maxValue = (recentSearch.value (forKey: "MaxValue") as? Double ?? 0)
                
                var lowerValue = NSNumber(value: Int(minValue!)).stringValue
                var upperValue = NSNumber(value: Int(maxValue!)).stringValue
                
                if Int(minValue!) > 999 {
                    lowerValue = NSNumber(value: Int(minValue!)/1000).stringValue
                }
                if Int(maxValue!) > 999 {
                    upperValue = NSNumber(value: Int(maxValue!)/1000).stringValue
                }
                
                
                selectedMinPrice = lowerValue
                selectedMaxPrice = upperValue
                
                displayString = "$\(lowerValue)K - $\(upperValue)K"
            }
        }
    }
        
    
    
    
    func returnValues () -> NSDictionary? {
        
        if selectedAnswer.count > 0 {
            
            let params = NSMutableDictionary ()
            params.setValue(self.featureName, forKey: "feature")
            params.setValue(self.question, forKey: "question")
            params.setValue(self.selectedAnswer, forKey: "Answer")
            
            return params
        }else {
            return nil
        }
    }
    
    
    
    
    func returnValuesForPrice () -> NSDictionary? {
        
        if self.featureName == "Lot Width" {
            
            if self.selectedAnswer.count > 0 {
                
                let params = NSMutableDictionary ()
                params.setValue(self.featureName, forKey: "feature")
                params.setValue(self.question, forKey: "question")
                params.setValue(self.selectedAnswer, forKey: "Answer")
                params.setValue("0.00", forKey: "MinValue")
                params.setValue(self.selectedAnswer, forKey: "MaxValue")
                
                print(self.selectedAnswer)
                print(params)
                
                return params
            }else {
                let params = NSMutableDictionary ()
                params.setValue(self.featureName, forKey: "feature")
                params.setValue(self.question, forKey: "question")
                params.setValue("I don't mind", forKey: "Answer")
                params.setValue("0.00", forKey: "MinValue")
                params.setValue(self.selectedAnswer, forKey: "MaxValue")
                
                print(self.selectedAnswer)
                print(params)
                
                return params
            }
        }else {
            
            if selectedMinPrice.count > 0 {
                
                let params = NSMutableDictionary ()
                params.setValue(self.featureName, forKey: "feature")
                params.setValue(self.question, forKey: "question")
                params.setValue(self.selectedMinPrice + "000", forKey: "MinValue")
                params.setValue(self.selectedMaxPrice + "000", forKey: "MaxValue")
                
                
                return params
            }else {
                return nil
            }
        }
    }
    
    
}



func addSpaceandnewValue (_ toValue: String, _ newValue: String?) -> String {
    if let value = newValue, newValue != "" {
        if toValue.trim().count > 0 {
            return toValue + " | " + value
        }else {
            return  value
        }
    }
    return toValue
}



extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}



class Answer: NSObject {
    
    var displayAnswer: String = ""
    var answerText: String = ""
    
    override init() {
        super.init()
        
    }
    

    init(answer: String) {
        super.init()
        
        if answer.components(separatedBy: ".").count > 1 {
            
            displayAnswer = (answer as NSString).floatValue.clean
            answerText = answer
        }else {
            answerText = String.checkNullValue (answer as Any)
            displayAnswer = String.checkNullValue (answer as Any)
        }
    }
    
    
    func addM () -> String {
        return displayAnswer+"M"
    }
    
}
