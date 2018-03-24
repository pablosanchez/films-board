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

    private let manager: CLLocationManager

    weak var delegate: MapViewModelDelegate?

    override init() {
        self.manager = CLLocationManager()
    }
}

extension MapViewModel {

    func getUserLocation() {
        self.manager.delegate = self
        self.manager.requestWhenInUseAuthorization()
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters // gps accuracy
    }

    func getMapData(region: MKCoordinateRegion) {
        MapDataProvider.requestMapData(forRegion: region, query: "cinemas") { [unowned self] (annotations, error) in
            guard let mapAnnotations = annotations else {
                self.delegate?.mapViewModel(self, didGetError: error?.message ?? "Error desconocido")
                return
            }

            self.delegate?.mapViewModel(self, didGetMapAnnotations: mapAnnotations)
        }
    }
}

extension MapViewModel: CLLocationManagerDelegate {

    // MARK: CLLocationManagerDelegate methods

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            guard let location = manager.location else {
                let error = "No ha sido posible determinar la ubicación del usuario."
                self.delegate?.mapViewModel(self, didGetError: error)
                return
            }
            self.delegate?.mapViewModel(self, didReceiveUserLocation: location)
        case .denied:
            let error = "Has denegado el permiso de ubicación. No podrás ver tus cines cercanos."
            self.delegate?.mapViewModel(self, didGetError: error)
        case .notDetermined, .authorizedAlways, .restricted:
            print("Other location permission: \(status)")
        }
    }
}

protocol MapViewModelDelegate: class {
    func mapViewModel(_ viewModel: MapViewModel, didReceiveUserLocation location: CLLocation)
    func mapViewModel(_ viewModel: MapViewModel, didGetMapAnnotations annotations: [MapAnnotation])
    func mapViewModel(_ viewModel: MapViewModel, didGetError error: String)
}
