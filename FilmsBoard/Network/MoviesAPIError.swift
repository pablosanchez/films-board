//
//  MoviesAPIError.swift
//  FilmsBoard
//
//  Created by Pablo on 12/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

enum MoviesAPIError: Error {
    case networkUnavailable(errorMessage: String)
    case apiError(code: Int)
}
