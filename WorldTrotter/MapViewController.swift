//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Erik Olson on 9/28/17.
//  Copyright © 2017 Erik Olson. All rights reserved.
//

// TODO have a '+' button that will add a pin using an api call to google maps to retrieve lat/long and create new pin.
// TODO when you 3D touch a pin you can delete it.

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {
 
    var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var pinAnnotationView: MKPinAnnotationView!
    var nextPinToZoomTo: Int = 1
    
    let pin1Location = CLLocationCoordinate2DMake(33.4936, -117.1484)
    let pin1 = MKPointAnnotation()
    let pin2Location = CLLocationCoordinate2DMake(35.6895, 139.6917)
    let pin2 = MKPointAnnotation()
    let pin3Location = CLLocationCoordinate2DMake(32.7940, 34.9896)
    let pin3 = MKPointAnnotation()
    
    override func loadView(){
        // create a map view
        mapView = MKMapView()
        
        // create a location manager
        locationManager = CLLocationManager()
        
        // create a pin annotation view
        pinAnnotationView = MKPinAnnotationView()
        
        // set "the" view (the root view) for the view controller to be mapView
        view = mapView
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
     
        // create the segmented control
        let standardString = NSLocalizedString("Standard", comment: "Standard Map View")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid Map View")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite Map View")
        let segmentedControl = UISegmentedControl(items: [standardString, hybridString, satelliteString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        // define margins of the root view so we can use properties like .topAnchor and .leadingAnchor
        let margins = view.layoutMarginsGuide
        
        let topConstraintSC = segmentedControl.topAnchor.constraint(equalTo: margins.topAnchor, constant: 20)
        let leadingConstraintSC = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraintSC = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        topConstraintSC.isActive = true
        leadingConstraintSC.isActive = true
        trailingConstraintSC.isActive = true
        
        // create a button for zooming to users location.
        let locationButton = UIButton(type: .custom)
        locationButton.alpha = 0.5
        locationButton.setBackgroundImage(#imageLiteral(resourceName: "CrosshairIcon"), for: .normal)
        
        // .addTarget adds a 3-way link - something happens to the target object or if nil, this will look up the first responder heirarchy to find something with a compatable control event (self), in this case locationButton, and then something else you specify happens (the action parameter), something happens (control event), that . If nil is specified for the first parameter, the target,
        locationButton.addTarget(self, action: #selector(MapViewController.zoomToUser(_:)), for: .touchUpInside)
        
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(locationButton)
        
        let bottomConstraintLB = locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        let trailingConstraintLB = locationButton.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        bottomConstraintLB.isActive = true
        trailingConstraintLB.isActive = true
        
        // create a button for zooming to pins sequentially upon taps.
        let nextPinButton = UIButton(type: .custom)
        nextPinButton.alpha = 0.5
        nextPinButton.setBackgroundImage(#imageLiteral(resourceName: "WebIcon"), for: .normal)
        
        nextPinButton.addTarget(self, action: #selector(MapViewController.viewNextPin(_:)), for: .touchUpInside)
        
        nextPinButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextPinButton)
        
        let bottomConstraintPB = nextPinButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        let trailingConstraintPB = nextPinButton.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        
        bottomConstraintPB.isActive = true
        trailingConstraintPB.isActive = true
        
        view.addSubview(pinAnnotationView)
        
        pin1.coordinate = pin1Location
        pin1.title = "Temecula"
        mapView.addAnnotation(pin1)
        
        pin2.coordinate = pin2Location
        pin2.title = "Tokyo"
        mapView.addAnnotation(pin2)
        
        pin3.coordinate = pin3Location
        pin3.title = "Haifa"
        mapView.addAnnotation(pin3)
        
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("MapViewController loaded its view.")
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0: mapView.mapType = .standard
        case 1: mapView.mapType = .hybrid
        case 2: mapView.mapType = .satellite
        default: break
        }
    }
    
    @objc func zoomToUser(_: UIButton) {
        if let userLocation = mapView.userLocation.location?.coordinate {
            mapView.setCenter(userLocation, animated: true)
            mapView.setRegion(MKCoordinateRegion(center: userLocation, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)), animated: true)
        }
    }
    
    @objc func viewNextPin(_: UIButton) {
        var pinLocation = pin1Location
            switch nextPinToZoomTo {
            case 1: do { pinLocation = pin1Location
                print("temec")
                }
            case 2: do { pinLocation = pin2Location
                print("tokyo")
                }
            case 3: do { pinLocation = pin3Location
                print("Haifa")
                }
            default: do { print(nextPinToZoomTo)
                break
                }
            }
        nextPinToZoomTo = nextPinToZoomTo == 3 ? 1 : nextPinToZoomTo + 1
        mapView.setCenter(pinLocation, animated: true)
        mapView.setRegion(MKCoordinateRegion(center: pinLocation, span: MKCoordinateSpanMake(1, 1)), animated: true)
    }
}
