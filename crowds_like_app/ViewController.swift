//
//  ViewController.swift
//  crowds_like_app
//
//  Created by Aldo Lugo on 9/29/16.
//  Copyright © 2016 Aldo Lugo. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var googleMapView: GMSMapView!
    var venuesManager: Venues = Venues()
    var locationManager: CLLocationManager!
    var currentLocation: [CLLocation] = []


    // Hide status bar
    override var prefersStatusBarHidden: Bool{
        get{
            return true
        }
    }
    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways{
//            print("authorizedAlways")
//        } else {
//            print("other auth")
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation.append(locations.last!)
        self.locationManager.stopUpdatingLocation()
        self.initGoogleMaps()
    }


    func initGoogleMaps(){
        let camera = GMSCameraPosition.camera(withLatitude: self.currentLocation.first!.coordinate.latitude, longitude: self.currentLocation.first!.coordinate.longitude, zoom: 12)
        self.googleMapView.isMyLocationEnabled = true
        self.googleMapView.camera = camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        let paddingview = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.searchField.frame.height))
        self.searchField.leftView = paddingview
        self.searchField.leftViewMode = UITextFieldViewMode.always
        self.addVenuesToMap(termToSerch: "tacos")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func addVenuesToMap(termToSerch: String){
        self.venuesManager.getLocations(term: termToSerch) { (result) in
            for item in result.arrayValue {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D( latitude: item["location"]["lat"].doubleValue, longitude: item["location"]["lng"].doubleValue)
                marker.title = item["name"].stringValue
                marker.snippet = item["location"]["address"].stringValue
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = self.googleMapView
            }
        }
    }


    @IBAction func searchBtn(_ sender: AnyObject) {
        if self.searchField.text != ""{
          self.googleMapView.clear()
          self.addVenuesToMap(termToSerch: self.searchField.text!)
          self.searchField.resignFirstResponder()
        } else {
            print("Please enter a search term")
        }
    }
}



