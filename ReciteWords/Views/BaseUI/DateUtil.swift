//
//  DateUtil.swift
//  ReciteWords
//
//  Created by jake on 2024/5/3.
//

import Foundation

class DateUtil {
    static var dateFormatter = DateFormatter()
    
    static func transDateToDayString(date:Date) -> String {
        // Set the desired format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // Convert the Date to a String
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func getCurrentDateString() -> String {
        // Set the desired format
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = Date()

        // Convert the Date to a String
        let dateString = dateFormatter.string(from: currentDate)

        return dateString
    }
    
    static func getDateFromString(dateString:String) -> Date {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // Convert the String to a Date
        let date = dateFormatter.date(from: dateString)
        return date!
    }
    
    static func getStartAndEndOfDate(date:Date) ->(Date,Date) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let end = calendar.date(byAdding: .second, value: -1, to: endOfDay)!
        return (startOfDay, end)
    }
    
    static func getAHundredDateArray() ->Array<(Date,Date)> {
        var resultArray = Array<(Date,Date)>()
        
        let today = Date()
        let calendar = Calendar.current
        for i in 0...100 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let item = self.getStartAndEndOfDate(date: date)
            resultArray.append(item)
        }
        return resultArray
    }
}

extension Date {

    func fullDistance(from date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }

    func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        return days1 - days2
    }

    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        distance(from: date, only: component) == 0
    }
}

