//
//  MediaItemsCategoryViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 19/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class MediaItemsCategoryViewModel: NSObject {

    private let storage: MediaItemsStorage

    @objc
    init(storage: MediaItemsStorage) {
        self.storage = storage
        super.init()
    }
}

@objc
protocol MediaItemsCategoryViewModelProvider: NSObjectProtocol {
    func mediaItemsCategoryViewModel() -> MediaItemsCategoryViewModel
}
