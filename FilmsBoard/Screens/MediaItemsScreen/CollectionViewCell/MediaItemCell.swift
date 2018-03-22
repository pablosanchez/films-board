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
        self.imageView.sd_setImage(with: URL(string: viewModel?.posterImageURL ?? "https://upload.wikimedia.org/wikipedia/commons/2/2b/No-Photo-Available-240x300.jpg"), completed: nil)
        self.label.text = viewModel?.title
    }
}
