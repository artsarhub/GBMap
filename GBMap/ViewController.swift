//
//  ViewController.swift
//  GBMap
//
//  Created by Артём on 05.11.2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import RealmSwift

class ViewController: UIViewController {
    // ЗАГЛУШКА ДЛЯ ДЗ 3
    
    // MARK: - Private vars
    
    private let redSquare = CLLocationCoordinate2D(latitude: 55.753215, longitude: 37.622504)
    //    private var marker: GMSMarker?
    //    private var manualMarker: GMSMarker?
    private var locationManager: CLLocationManager?
    private var route: GMSPolyline?
    private var routePath: GMSMutablePath?
    private var isUpdatingLocation = false
    private var realm: Realm?
    
    // MARK: - Outlets
    
    @IBOutlet weak var mapView: GMSMapView!
    
    // MARK: - IBActions
    
//    @IBAction func currentLocation(_ sender: Any) {
//        locationManager?.requestLocation()
//    }
    
    @IBAction func startTrack(_ sender: Any) {
//        self.locationManager?.startUpdatingLocation()
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
        isUpdatingLocation = true
    }
    
    @IBAction func finishTrack(_ sender: Any) {
        locationManager?.stopUpdatingLocation()
        isUpdatingLocation = false
        guard let routePath = routePath else { return }
        let bounds = GMSCoordinateBounds(path: routePath)
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
        self.saveTrack()
    }
    
    @IBAction func showLastTrack(_ sender: Any) {
        if isUpdatingLocation {
            let alert = UIAlertController(title: "Внимание", message: "Сначала остановите отслеживание", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            self.present(alert, animated: true)
        } else {
            self.getLastTrack()
        }
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
        do {
            try realm = Realm()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Private funcs
    
    private func saveTrack() {
        guard let routePath = routePath,
              let realm = realm
        else { return }
        let track = Track()
        for i in 0..<routePath.count() {
            track.points.append(Point(coordinate: routePath.coordinate(at: i)))
        }
        try? realm.write {
            realm.delete(realm.objects(Track.self))
            realm.add(track)
        }
    }
    
    private func getLastTrack() {
        guard let realm = realm,
              let lastTrack = realm.objects(Track.self).first
        else { return }
        
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        for point in lastTrack.points {
            routePath?.add(CLLocationCoordinate2D(latitude: point.lat, longitude: point.lon))
        }
        route?.path = routePath
        route?.map = mapView
        let bounds = GMSCoordinateBounds(path: routePath ?? GMSMutablePath())
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
    }
    
    private func configureMap() {
        //        mapView.settings.myLocationButton = true
        let camera = GMSCameraPosition(target: redSquare, zoom: 14)
        self.mapView.camera = camera
        self.mapView.delegate = self
    }
    
    private func configureLocationManager() {
        self.locationManager = CLLocationManager()
        self.locationManager?.allowsBackgroundLocationUpdates = true
        self.locationManager?.pausesLocationUpdatesAutomatically = false
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager?.requestAlwaysAuthorization()
//        self.locationManager?.requestWhenInUseAuthorization()
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
//        guard let coordinate = locations.first?.coordinate else { return }
//        mapView.animate(toLocation: coordinate)
//        let marker = GMSMarker(position: coordinate)
//        marker.map = self.mapView
        
        guard let location = locations.last else { return }
        routePath?.add(location.coordinate)
        route?.path = routePath
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 15)
        mapView.animate(to: position)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

