//
//  MapViewController.swift
//  01_wskpolice
//
//  Created by Admin on 17.06.2019.
//  Copyright © 2019 Rainblower. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    var coords = ""

    var latitude: CLLocationDegrees = 0
    var longtitude: CLLocationDegrees = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        map.delegate = self
        
        map.showsUserLocation = true

        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view.
        let annotation = MKPointAnnotation()
        
        coords = coords.trimmingCharacters(in: ["[","]"]).trimmingCharacters(in: .whitespacesAndNewlines)
        let newCoords = coords.split(separator: ",").map(String.init)
        
        latitude = CLLocationDegrees(Double(newCoords[0])!)
        longtitude = CLLocationDegrees(Double(newCoords[1].trimmingCharacters(in: .whitespacesAndNewlines))!)

        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude , longitude: longtitude )
        map.addAnnotation(annotation)
    }
}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let userLocation = locations.last
        
        let viewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longtitude), latitudinalMeters: 600, longitudinalMeters: 600)
        map.setRegion(viewRegion, animated: true)

        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation!.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(
            latitude: latitude, longitude: longtitude)))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        directions.calculate { (response, error) in
            guard let response = response else {
                
                let alert = UIAlertController(title: "Rout cant be build", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil)
                return
                
            }
            
            for route in response.routes {
                self.map.addOverlay(route.polyline)
                self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        render.strokeColor = .blue
        render.lineWidth = 2
        return render
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
