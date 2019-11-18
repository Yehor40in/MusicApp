//
//  MapViewController.swift
//  MusicApp
//
//  Created by Yehor Sorokin on 18.11.2019.
//  Copyright © 2019 Yehor Sorokin. All rights reserved.
//

import UIKit
import MapKit
import Foundation

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark: MKPlacemark)
}

final class MapViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var mapView: MKMapView!
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var userCenter: CLLocationCoordinate2D!
    private var mapCenter: CLLocationCoordinate2D!
    private var resultSearchController: UISearchController!
    private var selectedPin: MKPlacemark!
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        mapView.showsUserLocation = true
        setupSearchController()
    }
    func setupSearchController() {
        let locationSearchTable = storyboard?.instantiateViewController(
            withIdentifier: "LocationSearchTable"
        ) as? LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.searchController = resultSearchController
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        locationSearchTable?.mapView = mapView
        locationSearchTable?.delegate = self
    }
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLHeadingFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
}

extension MapViewController: CLLocationManagerDelegate {
    // MARK: - LocationManager Delegate
    private func locationManager(
        manager: CLLocationManager,
        didChangeAuthorizationStatus status: CLAuthorizationStatus
    ) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
        userCenter = CLLocationCoordinate2D(
            latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude
        )
        let region = MKCoordinateRegion(
            center: userCenter,
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        )
        mapView.setRegion(region, animated: true)
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
        let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let region = MKCoordinateRegion(
            center: placemark.coordinate,
            span: MKCoordinateSpan(
                latitudeDelta: 0.05,
                longitudeDelta: 0.05
            )
        )
        mapView.setRegion(region, animated: true)
    }
}
