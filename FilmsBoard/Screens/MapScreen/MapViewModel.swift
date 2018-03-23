//
//  MapViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 22/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class MapViewModel: NSObject {

    override init() {

    }
}

@objc
protocol MapViewModelProvider: NSObjectProtocol {
    func mapViewModel() -> MapViewModel
}
