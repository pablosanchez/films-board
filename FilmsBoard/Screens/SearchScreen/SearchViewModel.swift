//
//  SearchViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 20/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation

@objc
class SearchViewModel: NSObject {

    private(set) var cellViewModels: [MediaItemDetailedCellViewModel] = []
    private let storage: MediaItemsStorage

    private var currentPage: Int
    var totalPages: Int?  // To handle infinite scrolling

    var searchText: String?
    var index: Int?

    weak var delegate: SearchViewModelDelegate?

    @objc
    init(storage: MediaItemsStorage) {
        self.storage = storage
        self.currentPage = 1
    }
}

extension SearchViewModel {

    private func updateCellViewModels() {
        let mediaItems = storage.mediaItemsByTextSearch
        self.cellViewModels = mediaItems.map { (mediaItem) -> MediaItemDetailedCellViewModel in
            return MediaItemDetailedCellViewModel(model: mediaItem)
        }
    }
}

extension SearchViewModel {

    func performSearchRequest(text: String?, index: Int) {
        guard let text = text, text.count > 0, let type = self.type(forIndex: index) else {
            let error = "Introduce texto en la barra de búsqueda para poder realizar la petición"
            delegate?.searchViewModel(self, didGetError: error)
            return
        }

        if self.searchText ?? "" != text || self.index ?? -1 != index {
            self.currentPage = 1  // Reset current page to 1 when search request has changed
        }

        self.searchText = text
        self.index = index

        let apiManager = MoviesAPIManager(storage: storage)
        apiManager.getMediaItemsByText(text: text, type: type, page: currentPage) { [unowned self] (pages, error) in
            guard error == nil else {
                var errorMsg: String
                if let error = error as? MoviesAPIError {
                    switch error {
                    case .apiError(let code):
                        errorMsg = "Error de red: código HTTP \(code)"
                    case .networkUnavailable(let errorMessage):
                        errorMsg = errorMessage
                    }
                } else if let error = error as? MediaItemsBuilderError {
                    errorMsg = error.errorMessage
                } else {
                    errorMsg = "Error desconocido"
                }

                self.delegate?.searchViewModel(self, didGetError: errorMsg)
                return
            }

            self.totalPages = pages?[0] ?? 1  // If there were no pages, use a default value of 1
            self.updateCellViewModels()
            self.delegate?.searchViewModelDidUpdateData(self)
        }
    }

    func getNextMediaItemsPage() {
        self.currentPage += 1

        guard self.currentPage <= self.totalPages ?? 1 else {
            delegate?.searchViewModelDidFinishUpdatingData(self)
            return
        }

        self.performSearchRequest(text: self.searchText, index: self.index ?? 0)
    }
}

extension SearchViewModel {

    // Map segmented control selected index to corresponding MediaItemTypes
    private func type(forIndex index: Int) -> MediaItemTypes? {
        return MediaItemTypes(rawValue: index)
    }
}

protocol SearchViewModelDelegate: class {
    func searchViewModelDidUpdateData(_ viewModel: SearchViewModel)
    func searchViewModelDidFinishUpdatingData(_ viewModel: SearchViewModel)
    func searchViewModel(_ viewModel: SearchViewModel, didGetError errorMessage: String)
}

@objc
protocol SearchViewModelProvider: NSObjectProtocol {
    func searchViewModel() -> SearchViewModel
}
