//
//  LocationServices.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 02/09/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import CoreLocation

class LocationServices: NSObject, CLLocationManagerDelegate {

    static let shared = LocationServices ()
    
    var locationManager: CLLocationManager?
    var K_GETlocationCORD : CLLocationCoordinate2D?
    
    override init() {
        super.init()
        
    }
    
    func onLocationService () {
        
        if CLLocationManager.locationServicesEnabled() == true {
            //settings
            switch authorizationStatus() {
            case .restricted, .denied :
                print(log: "removed access")
                self.offLocationServices ()
                
            case .authorizedAlways, .authorizedWhenInUse :
                print(log: "Access available")

            case .notDetermined:
                print(log: "Not determined")
                self.requestUsertoAllowLocationPermissions()
                
            default:
                print(log: "Default")

            }
        }else {
            
            offLocationServices ()
        }
    }
    
    
    func offLocationServices () {
        
        if let url = URL (string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:]) { (succ) in
                
            }
        }
    }
    
    func isLocationServicesEnabled () -> Bool {
            if CLLocationManager.locationServicesEnabled() == true {
                switch authorizationStatus() {
                case .restricted, .denied :
                    print(log: "No access")
                    return false
                case .authorizedAlways, .authorizedWhenInUse :
                    print(log: "Access")
                    locationManager?.startUpdatingLocation()
                    locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                    return true
                case .notDetermined:
                    print(log: "No access")
                    return false
                default:
                    print(log: "No access")
                    return false
                }
            }else {
                return false
            }
       
       
    }
    
    func requestUsertoAllowLocationPermissions () {
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        

    }
    
    func authorizationStatus () -> CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus ()
    }
    
    
    
    //MARK: - Location Delegates
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
//        if status == .authorizedWhenInUse, status == .authorizedWhenInUse {
//            appDelegate.userData?.user?.userDetails?.locationServices.isOn = true
//        }else {
//            appDelegate.userData?.user?.userDetails?.locationServices.isOn = false
//        }
//
//        appDelegate.userData?.saveUserDetails()
//        appDelegate.userData?.loadUserDetails()
        
        NotificationCenter.default.post(name: NSNotification.Name (kLocationPermissionChanges), object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
          let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: locationupdated), object: nil, userInfo: ["loc":locValue])

        self.K_GETlocationCORD = locValue
        print(self.K_GETlocationCORD as Any)
  
//          mapView.mapType = MKMapType.standard
//
//          let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//          let region = MKCoordinateRegion(center: locValue, span: span)
//          mapView.setRegion(region, animated: true)
//
//          let annotation = MKPointAnnotation()
//          annotation.coordinate = locValue
//          annotation.title = "Burbank"
//          annotation.subtitle = "current location"
//          mapView.addAnnotation(annotation)
  
          //centerMap(locValue)
      }
        
}
let locationupdated = "didLocationupdate"
