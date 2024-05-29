//
//  googleMapViewController.swift
//  Scifalre_Task
//
//  Created by mac on 28/05/24.
//

import UIKit
import GoogleMaps

class googleMapViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map_View: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    
    var locationManager = CLLocationManager()
    let options = GMSMapViewOptions()
    var mapView = GMSMapView()
    
    private var currentlatitude = ""
    private var currentlongitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.popupView.frame = UIScreen.main.bounds
        view.addSubview(self.popupView)
        self.popupView.isHidden = true
        options.camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
        options.frame = self.view.bounds
       
        self.mapView = GMSMapView(options: options)
      
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
  
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
       
        self.map_View.addSubview(mapView)
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
    }

    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        popupView.isHidden = false
        latitudeLbl.text = "Current Latitude : \(coordinate.latitude)"  
        longitudeLbl.text = "Current Longitude : \(coordinate.longitude)"
        print("You have lat and long:",coordinate.latitude,",",coordinate.longitude)
        let marker = GMSMarker(position: coordinate)
        marker.title = "Hello World"
        marker.map =  self.mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        popupView.isHidden = false
        if let location = locations.last {
            latitudeLbl.text = "Current Latitude : \(location.coordinate.latitude)"  // Convert Double to String
            longitudeLbl.text = "Current Longitude : \(location.coordinate.longitude)"  // Convert Double to String
            let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude, longitude: location.coordinate.longitude, zoom: 17.0)
            self.locationManager.stopUpdatingLocation()
        }
        
    }
    
    @IBAction func MapBack_Tapped(_ sender: UIButton){
        popViewController()
    }
    @IBAction func popUpDone_Tapped(_ sender: UIButton){
        popupView.isHidden = true
    }
}
