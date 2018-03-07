//
//  Coordinable.swift
//  FilmsBoard
//
//  Created by Pablo on 07/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit

protocol Coordinable {

    /**
     The root view controller for the coordinator
     */
    var rootViewController: UIViewController { get }

    /**
     Initial configuration for the coordinator
     */
    func start()
}
