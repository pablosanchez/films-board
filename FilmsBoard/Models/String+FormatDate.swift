//
//  String+DateFormat.swift
//  FilmsBoard
//
//  Created by Pablo on 20/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

extension String {

    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.current
        
        let dateOpt = dateFormatter.date(from: self)

        guard let date = dateOpt else {
            return ""
        }

        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
}
