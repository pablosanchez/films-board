//
//  DateUtils.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 22/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation


@objc class DateUtils: NSObject {
    
    
    func getDateFromString(stringDate: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale?
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let date = dateFormatter.date(from: stringDate)
        
        return date!
    }
}
