//
//  ViewController.swift
//  GBMap
//
//  Created by Артём on 05.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Private vars
    
    private let redSquare = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    //    private var marker: GMSMarker?
    //    private var manualMarker: GMSMarker?
    private var locationManager: CLLocationManager?
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - IBActions
    
    @IBAction func currentLocation(_ sender: Any) {
        locationManager?.requestLocation()
    }
    
    @IBAction func updateLocation(_ sender: Any) {
        self.locationManager?.startUpdatingLocation()
    }
    
    //    @IBAction func goTo(_ sender: Any) {
    //        mapView.animate(toLocation: redSquare)
    //    }
    //
    //    @IBAction func addMarkerAction(_ sender: Any) {
    //        if marker != nil {
    //            removeMarker()
    //        } else {
    //            addMarker(position: redSquare)
    //        }
    //    }
    
    // MARK: - View set up
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        configureMapStyle()
        configureMap()
        configureLocationManager()
    }
    
    // MARK: - Private funcs
    
    private func configureMap() {
        //        mapView.settings.myLocationButton = true
        let camera = GMSCameraPosition(target: redSquare, zoom: 14)
        self.mapView.camera = camera
        self.mapView.delegate = self
    }
    
    private func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.delegate = self
    }
    
    //    private func addMarker(position: CLLocationCoordinate2D) {
    //        let marker = GMSMarker(position: position)
    //        marker.icon = GMSMarker.markerImage(with: .green)
    //        marker.title = "Красная площадь"
    //        marker.map = self.mapView
    //        self.marker = marker
    //    }
    
    //    private func removeMarker() {
    //        marker?.map = nil
    //        marker = nil
    //    }
    
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        //        if let manualMarker = manualMarker {
        //            manualMarker.position = coordinate
        //        } else {
        //            let marker = GMSMarker(position: coordinate)
        //            marker.map = mapView
        //            self.manualMarker = marker
        //        }
    }
}

// MARK: - Extensions

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        mapView.animate(toLocation: coordinate)
        let marker = GMSMarker(position: coordinate)
        marker.map = self.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

