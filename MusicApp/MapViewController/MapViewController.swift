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
    @IBOutlet private weak var homeLocation: UIButton!
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var mapCenter: CLLocationCoordinate2D!
    private var userLocation: CLLocationCoordinate2D!
    private var resultSearchController: UISearchController!
    private var selectedPin: MKPlacemark!
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        mapView.showsUserLocation = true
        homeLocation.layer.cornerRadius = Config.cornerRadiusPlaceholder
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
        navigationItem.largeTitleDisplayMode = .never
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
    func setRegion(with center: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(
            center: center,
            span: MKCoordinateSpan(
                latitudeDelta: 0.05,
                longitudeDelta: 0.05
            )
        )
        mapView.setRegion(region, animated: true)
    }
    @IBAction func homePressed(_ sender: Any) {
        setRegion(with: userLocation)
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
        guard let location = locations.last else { return }
        if let locationUser = locations.first {
            userLocation = CLLocationCoordinate2D(
                latitude: locationUser.coordinate.latitude,
                longitude: locationUser.coordinate.longitude
            )
        }
        mapCenter = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        setRegion(with: mapCenter)
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
        setRegion(with: placemark.coordinate)
    }
}
