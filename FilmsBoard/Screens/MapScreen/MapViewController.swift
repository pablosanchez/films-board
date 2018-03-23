//
//  MapViewController.swift
//  FilmsBoard
//
//  Created by Pablo on 22/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!

    private let viewModel: MapViewModel

    init(viewModel: MapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = self.segmentedControl
        self.initSegmentedControl()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let initialLocation = CLLocation(latitude: 40.9690231, longitude: -5.6653289)
        self.centerMapOnLocation(initialLocation, withSpan: 0.07)
    }
    
    @IBAction func segmentedControlDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.mapView.mapType = .standard
        case 1:
            self.mapView.mapType = .satelliteFlyover
        case 2:
            self.mapView.mapType = .hybridFlyover
        default:
            self.mapView.mapType = .standard
        }
    }
}

extension MapViewController {

    private func initSegmentedControl() {
        self.segmentedControl.setTitle("Estándar", forSegmentAt: 0)
        self.segmentedControl.setTitle("Satélite", forSegmentAt: 1)
        self.segmentedControl.setTitle("Híbrido", forSegmentAt: 2)
    }

    private func centerMapOnLocation(_ location: CLLocation, withSpan span: Double) {
        let spanRegion = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let mapRegion = MKCoordinateRegion(center: location.coordinate, span: spanRegion)
        mapView.setRegion(mapRegion, animated: true)
    }
}
