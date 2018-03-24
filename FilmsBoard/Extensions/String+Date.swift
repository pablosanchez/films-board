//
//  String+Date.swift
//  FilmsBoard
//
//  Created by Pablo on 24/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

extension String {

    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Madrid")
        return dateFormatter.date(from: self)
    }
}
