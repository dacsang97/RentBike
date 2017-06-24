//
//  MainViewController.swift
//  RentBi
//
//  Created by mac on 6/24/17.
//  Copyright © 2017 vteam. All rights reserved.
//

import UIKit
import GoogleMaps

class MainViewController: UIViewController , GMSMapViewDelegate , CLLocationManagerDelegate {

    @IBOutlet var btnView: UIView!
    @IBOutlet var mapView: GMSMapView!
    @IBOutlet var btnOutlet: [UIButton]!
    var locationManager = CLLocationManager()
    
    @IBOutlet var btnUserLocation: UIButton!
    @IBOutlet var btnParking: UIButton!
    @IBOutlet var btnRentBike: UIButton!
    @IBOutlet var btnGasStation: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

     //   let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 13.0)
       // mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        // User Location
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()

     
        self.view.insertSubview(mapView, at: 0)
        self.view.insertSubview(btnView, at: 1)
        btnUserLocation.layer.cornerRadius = 20
        btnGasStation.layer.cornerRadius = 20
        btnParking.layer.cornerRadius = 20
        btnRentBike.layer.cornerRadius = 20

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
//    //Location Manager delegates
//    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        
//        let location = locations.last
//        
//        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
//        
//        self.mapView?.animate(to: camera)
//        
//        //Finally stop updating location otherwise it will come again and again in this delegate
//        self.locationManager.stopUpdatingLocation()
//        
//    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let camera = GMSCameraPosition.camera(withLatitude: userLocation!.coordinate.latitude,
                                              longitude: userLocation!.coordinate.longitude, zoom: 13.0)
       // mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        //self.view = mapView
        
        locationManager.stopUpdatingLocation()
        
        
        
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
