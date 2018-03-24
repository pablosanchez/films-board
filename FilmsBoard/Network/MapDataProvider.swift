//
//  MapDataProvider.swift
//  FilmsBoard
//
//  Created by Pablo on 23/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import Foundation
import MapKit

struct MapDataProvider {

    typealias Completion = ([MapAnnotation]?, RequestError?) -> ()

    static func requestMapData(forRegion region: MKCoordinateRegion, query: String, completion: @escaping Completion) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = query
        request.region = region

        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                let errorMessage = "Error desconocido"
                let err = RequestError(message: "Error al buscar \(request.naturalLanguageQuery!): \(error?.localizedDescription ?? errorMessage)")
                completion(nil, err)
                return
            }

            var annotations: [MapAnnotation] = []
            for cinema in response.mapItems {
                let annotation = MapAnnotation(title: cinema.name, subtitle: cinema.phoneNumber, coordinate: cinema.placemark.coordinate)
                annotations.append(annotation)
            }
            completion(annotations, nil)
        }
    }
}
