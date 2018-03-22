//
//  MediaItemCell.swift
//  FilmsBoard
//
//  Created by Pablo on 19/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage

class MediaItemDetailedCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!

    var viewModel: MediaItemDetailedCellViewModel? {
        didSet {
            self.bindViews()
        }
    }

    private func bindViews() {
        self.imageView.sd_setImage(with: URL(string: viewModel?.posterImageURL ?? "https://upload.wikimedia.org/wikipedia/commons/2/2b/No-Photo-Available-240x300.jpg"), completed: nil)
        self.titleLabel.text = viewModel?.title
        self.releaseDateLabel.text = viewModel?.releaseDate
        self.ratingView.rating = viewModel?.rating ?? 0.0
    }
}
