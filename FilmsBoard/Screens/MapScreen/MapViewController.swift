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
        self.viewModel.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = self.segmentedControl
        self.initSegmentedControl()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.viewModel.getUserLocation()
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

    private func centerMapOnLocation(_ location: CLLocation, withSpan span: Double) -> MKCoordinateRegion {
        let spanRegion = MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        let mapRegion = MKCoordinateRegion(center: location.coordinate, span: spanRegion)
        self.mapView.setRegion(mapRegion, animated: true)
        return mapRegion
    }
}

extension MapViewController: MapViewModelDelegate {

    // MARK: MapViewModelDelegate methods

    func mapViewModel(_ viewModel: MapViewModel, didReceiveUserLocation location: CLLocation) {
        let mapRegion = self.centerMapOnLocation(location, withSpan: 0.05)
        self.viewModel.getMapData(region: mapRegion)
    }

    func mapViewModel(_ viewModel: MapViewModel, didGetMapAnnotations annotations: [MapAnnotation]) {
        self.mapView.addAnnotations(annotations)
    }

    func mapViewModel(_ viewModel: MapViewModel, didGetError error: String) {
        SCLAlertViewBuilder()
            .setTitle("Aviso")
            .setSubtitle(error)
            .setCloseButtonTitle("Ok")
            .show()
    }
}

extension MapViewController: MKMapViewDelegate {

    // MARK: MKMapViewDelegate methods

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MapAnnotation else {
            return nil
        }

        let identifier = "map-marker"
        var view: MKPinAnnotationView

        if let reusedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
            view = reusedView
        } else {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }

        return view
    }

    // Open maps application in walking mode when accessory button is tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! MapAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking]
        location.toMapItem().openInMaps(launchOptions: launchOptions)
    }
}
