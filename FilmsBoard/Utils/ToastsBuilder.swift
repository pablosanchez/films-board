//
//  ToastsMaker.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 25/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import MBProgressHUD

struct ToastsBuilder {
    
    static func makeToast(text: String, view: UIView) {
        let toast = MBProgressHUD.showAdded(to: view, animated: true)
        toast.label.text = text
        toast.mode = .text
        toast.margin = 10
        toast.offset.y = 150
        toast.removeFromSuperViewOnHide = true
        
        toast.hide(animated: true, afterDelay: 3)
    }
}
