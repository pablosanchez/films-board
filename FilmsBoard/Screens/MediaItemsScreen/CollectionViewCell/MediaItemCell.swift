//
//  MediaItemCell.swift
//  FilmsBoard
//
//  Created by Pablo on 08/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import SDWebImage

class MediaItemCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!

    var viewModel: MediaItemViewModel? {
        didSet {
            self.bindViews()
        }
    }

    private func bindViews() {
        self.imageView.sd_setImage(with: URL(string: viewModel?.posterImageURL ?? "http://abqpride.com/no-image-available/"), completed: nil)
        self.label.text = viewModel?.title
    }
}
