//
//  MBProgressHUDBuilder.swift
//  FilmsBoard
//
//  Created by Pablo on 22/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import MBProgressHUD

struct MBProgressHUDBuilder {

    static func makeProgressIndicator(view: UIView) -> MBProgressHUD {
        let progressIndicator = MBProgressHUD.showAdded(to: view, animated: true)
        progressIndicator.label.text = "Cargando..."
        progressIndicator.mode = .indeterminate

        return progressIndicator
    }
}
