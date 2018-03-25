//
//  MapAnnotation.swift
//  FilmsBoard
//
//  Created by Pablo on 23/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation {

    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D

    init(title: String? = nil, subtitle: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

extension MapAnnotation {

    // Source: https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started
    func toMapItem() -> MKMapItem {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
