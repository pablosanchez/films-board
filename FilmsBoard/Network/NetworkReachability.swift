//
//  NetworkReachability.swift
//  FilmsBoard
//
//  Created by Pablo on 24/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import Reachability

@objc
class NetworkReachability: NSObject {

    let reachability: Reachability

    override init() {
        self.reachability = Reachability()!
    }

    // Check if network connection is avaiable
    var connection: Bool {
        return reachability.connection != .none
    }
}
