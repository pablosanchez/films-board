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
        dateFormatter.dateFormat = "dd-MM yyyy"
        dateFormatter.locale = Locale(identifier: "es")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Madrid")
        return dateFormatter.date(from: self)
    }
}
