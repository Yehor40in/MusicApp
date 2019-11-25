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

protocol SearchDelegate: class {
    func dropPinZoomIn(placemark: MKPlacemark)
}

final class MapViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var homeLocation: UIButton!
    @IBOutlet weak var getPlaylistBtn: UIButton!
    @IBOutlet weak var getPlaylistBtnBottom: NSLayoutConstraint!
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private var mapCenter: CLLocationCoordinate2D?
    private var userLocation: CLLocationCoordinate2D?
    private var resultSearchController: UISearchController!
    private var travelTime: TimeInterval?
    private var selectedPin: MKPlacemark?
    var player = MusicPlayer.shared
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        mapView.showsUserLocation = true
        mapView.delegate = self
        homeLocation.layer.cornerRadius = Config.cornerRadiusPlaceholder
        getPlaylistBtn.layer.cornerRadius = Config.cornerRadiusPlaceholder
        setupSearchController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlaylistBtn.isHidden = true
        getPlaylistBtn.alpha = 0
        getPlaylistBtnBottom.constant = 10
        view.layoutIfNeeded()
    }
    // MARK: - Methods
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
        navigationItem.title = "Where would you like to go?"
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        locationSearchTable?.mapView = mapView
        locationSearchTable?.delegate = self
    }
    func animateGetPlaylistBtn() {
        getPlaylistBtnBottom.constant = 30
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.getPlaylistBtn.isHidden = false
            self?.getPlaylistBtn.alpha = 1
            self?.view.layoutIfNeeded()
        })
    }
    func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLHeadingFilterNone
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    func drawRoute(to destination: MKPlacemark) {
        mapView.removeOverlays(mapView.overlays)
        let directionRequest = MKDirections.Request()
        guard let userLoc = userLocation else { return }
        directionRequest.source = MKMapItem(placemark: MKPlacemark(coordinate: userLoc))
        directionRequest.destination = MKMapItem(placemark: destination)
        directionRequest.transportType = .walking

        let directions = MKDirections(request: directionRequest)
        directions.calculate { [unowned self] (response, _) in
            guard let directionResonse = response else { return }
            let route = directionResonse.routes[0]
            self.travelTime = route.expectedTravelTime
            self.animateGetPlaylistBtn()
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
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
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let ctrl = segue.destination as? PlaylistController {
            guard let last = PlaylistManager.getLastPlaylist() else { return }
            ctrl.info = last
        }
    }
    // MARK: - Actions
    @IBAction func homePressed(_ sender: Any) {
        guard let location = userLocation else { return }
        setRegion(with: location)
    }
    @IBAction func getPlaylistPressed(_ sender: Any) {
        guard let travelTime = travelTime else { return }
        if player.getRoutePlaylist(for: travelTime) {
            performSegue(withIdentifier: "GoToPlaylist", sender: nil)
        }
    }
}
// MARK: - LocationManager Delegate
extension MapViewController: CLLocationManagerDelegate {
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
        guard let center = mapCenter else { return }
        setRegion(with: center)
    }
}
// MARK: - LocationSearch Delegate
extension MapViewController: SearchDelegate {
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
        drawRoute(to: placemark)
    }
}
// MARK: - MapView Delegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
}
