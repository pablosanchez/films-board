//
//  MapViewModel.swift
//  FilmsBoard
//
//  Created by Pablo on 22/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import MapKit

@objc
class MapViewModel: NSObject {

    weak var delegate: MapViewModelDelegate?

    override init() { }
}

extension MapViewModel {

    func getMapData(region: MKCoordinateRegion) {
        MapDataProvider.requestMapAnnotations(region: region) { [unowned self] (annotations, error) in
            guard let mapAnnotations = annotations else {
                self.delegate?.mapViewModel(self, didGetError: error?.message ?? "Error desconocido")
                return
            }

            self.delegate?.mapViewModel(self, didGetData: mapAnnotations)
        }
    }
}

protocol MapViewModelDelegate: class {
    func mapViewModel(_ viewModel: MapViewModel, didGetData annotations: [MapAnnotation])
    func mapViewModel(_ viewModel: MapViewModel, didGetError error: String)
}
