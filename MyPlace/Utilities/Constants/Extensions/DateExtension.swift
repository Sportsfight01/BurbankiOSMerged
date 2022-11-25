//
//  DateExtension.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 04/05/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import Foundation

extension Date {
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
//    func dayNumberOfWeek() -> Int? {
//        return Calendar.current.dateComponents([.weekday], from: self).weekday
//    }
    
    func dateNumber() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        
        return dateFormatter.string(from: self)
    }
    
//    func monthNumber() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM"
//
//        return dateFormatter.string(from: self)
//    }
    
    func year() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    func getNextMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: 1, to: self)
    }

    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }
    
    func dateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        return dateFormatter.string(from: self)
    }
    
    
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

    
    func isBetween(startDate:Date, endDate:Date)->Bool
    {
        if (startDate.compare(self) == .orderedSame)
        {
            return true;
        }
        else
        {
            return (startDate.compare(self) == .orderedAscending) && (endDate.compare(self) == .orderedDescending )

        }
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    var dayValue: Int
    {
        return Calendar.current.component(.day, from: self)
    }
    var monthNumber:Int
    {
        return Calendar.current.component(.month, from: self)
    }
    var presentYear : Int
    {
        return Calendar.current.component(.year, from: self)
    }
    //    var dayMonthYear: (Int, Int, Int) {
    //            let components = NSCalendar.currentCalendar.components([.day, .month, .year], fromDate: self)
    //            return (components.day, components.month, components.year)
    //        }
    var presentHour: Int
    {
        var calender = Calendar(identifier: .gregorian)
        calender.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        return calender.component(.hour, from: self) //Calendar.current.component(.hour, from: self)
    }
    var presentMinute: Int
    {
        var calender = Calendar(identifier: .gregorian)
        calender.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        return calender.component(.minute, from: self)
    }
    var presentSecond: Int
    {
        var calender = Calendar(identifier: .gregorian)
        calender.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        return calender.component(.second, from: self)
    }
    func timeAgoDisplay() -> String
    {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        if secondsAgo > 0
        {
            if secondsAgo < minute
            {
                return "\(secondsAgo) seconds Ago"
            }else if secondsAgo < hour
            {
                return "\(secondsAgo / minute) mintues Ago"
            }else if secondsAgo < day
            {
                return "\(secondsAgo / hour) hours Ago"
            }else if secondsAgo < week
            {
                return "\(secondsAgo / day) days Ago"
            }else if secondsAgo < month
            {
                return "\(secondsAgo / week) weeks Ago"
            }else if secondsAgo < year
            {
                return "\(secondsAgo / month) Months Ago"
            }
        }else
        {
            let absoluteValue = abs(secondsAgo)
            if absoluteValue < minute
            {
                return "\(absoluteValue) seconds Later"
            }else if absoluteValue < hour
            {
                return "\(absoluteValue / minute) mintues Later"
            }else if absoluteValue < day
            {
                return "\(absoluteValue / hour) hours Later"
            }else if absoluteValue < week
            {
                return "\(absoluteValue / day) days Later"
            }else if absoluteValue < month
            {
                return "\(absoluteValue / week) weeks Later"
            }else if absoluteValue < year
            {
                return "\(absoluteValue / month) Months Later"
            }
        }

      
        return "\(secondsAgo / year) Years Ago"
    }
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            
            if let month = interval.month, month > 0 {
                return (year == 1 ? "\(year)" + " " + "year and " :
                    "\(year)" + " " + "years and ") + (month == 1 ? "\(month)" + " " + "month ago" :
                    "\(month)" + " " + "months ago")
            }
            else {
                return year == 1 ? "\(year)" + " " + "year ago" :
                    "\(year)" + " " + "years ago"
            }
            
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        } else {
            return "a moment ago"
            
        }
        
    }
    
    
}
