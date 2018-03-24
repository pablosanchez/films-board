//
//  ListsViewCell.swift
//  FilmsBoard
//
//  Created by Javier Garcia on 24/3/18.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import CarbonBadgeLabel

class ListsViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var count: CarbonBadgeLabel!
    
    
    var viewModel: ListCellViewModel? {
        didSet {
            self.bindViews()
        }
    }
    
    private func bindViews() {
        self.title.text = viewModel?.title
        
        if let vm = viewModel {
            self.count.text = String(vm.count)
        } else {
            self.count.text = "0"
        }
    }
}
