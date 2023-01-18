//
//  MyPlaceMaps.swift
//  MyPlace
//
//  Created by sreekanth reddy Tadi on 02/07/20.
//  Copyright © 2020 Sreekanth tadi. All rights reserved.
//

import UIKit
import GoogleMaps
import GoogleMapsUtils



class MyPlaceMap: GMSMapView {
    
    var allMarkers = [MyPlaceMarker]()
    var NearByallMarkers = [NearByPlaceMarkers]()
    var designLocationMarkers = [designLocationMark]()
    
    var btnZoomIn = UIButton ()
    var btnZoomOut = UIButton ()
    
    var zoomLevel: Float = 10.0
    
    
    
    func addZoomLevelButtons () {
        
        btnZoomIn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btnZoomIn)
        
        btnZoomOut.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btnZoomOut)
        
        
        NSLayoutConstraint.activate([
            btnZoomIn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            btnZoomIn.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            btnZoomIn.heightAnchor.constraint(equalToConstant: 20),
            btnZoomIn.widthAnchor.constraint(equalToConstant: 20),
        ])
        
        NSLayoutConstraint.activate([
            btnZoomOut.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            btnZoomOut.topAnchor.constraint(equalTo: btnZoomIn.bottomAnchor, constant: 10),
            btnZoomOut.heightAnchor.constraint(equalToConstant: 20),
            btnZoomOut.widthAnchor.constraint(equalToConstant: 20),
        ])
        
        
        
        btnZoomIn.setTitle("+", for: .normal)
        btnZoomOut.setTitle("-", for: .normal)
        
        setAppearanceFor(view: btnZoomIn, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_BUTTON_HEADING(size: 20))
        setAppearanceFor(view: btnZoomOut, backgroundColor: APPCOLORS_3.HeaderFooter_white_BG, textColor: APPCOLORS_3.Black_BG, textFont: FONT_BUTTON_HEADING(size: 20))
        
        
        btnZoomOut.addTarget(self, action: #selector(handleZoomButtons(_:)), for: .touchUpInside)
        btnZoomIn.addTarget(self, action: #selector(handleZoomButtons(_:)), for: .touchUpInside)
        
    }
    
    
    func setMapPosition (with region: RegionMyPlace?, zoomlevel: Float = 10.0) {
        
        var lati = "-33.865143"
        var longi = "151.209900"
        
        if let reg = region {
            if reg.regionLatitude.count > 0 {
                lati = reg.regionLatitude
                longi = reg.regionLongitude
            }
        }
        
        self.camera = GMSCameraPosition (target: CLLocationCoordinate2D (latitude: (lati as NSString).doubleValue, longitude: (longi as NSString).doubleValue ), zoom: zoomlevel)
        self.clear()
        
        
        zoomLevel = zoomlevel
    }
//    func setMapPosition (with displayDetails: houseDetailsByHouseType?, zoomlevel: Float = 10.0) {
//        
//        var lati = "-33.865143"
//        var longi = "151.209900"
//        
//        if let reg = displayDetails {
//            if let lat = reg.latitude {
//                if lat.count > 0 {
//                    lati = reg.latitude!
//                    longi = reg.longitude!
//                }
//            }
//        }
//        self.camera = GMSCameraPosition (target: CLLocationCoordinate2D (latitude: (lati as NSString).doubleValue, longitude: (longi as NSString).doubleValue ), zoom: zoomlevel)
//        self.clear()
//        
//        
//        zoomLevel = zoomlevel
//    }
    
    func setMapPosition (with homeLandPackage: HomeLandPackage?, zoomlevel: Float = 10.0) {
        
        var lati = "-33.865143"
        var longi = "151.209900"
        
        if let reg = homeLandPackage {
            if let lat = reg.latitude {
                if lat.count > 0 {
                    lati = reg.latitude!
                    longi = reg.longitude!
                }
            }
        }
        
        self.camera = GMSCameraPosition (target: CLLocationCoordinate2D (latitude: (lati as NSString).doubleValue, longitude: (longi as NSString).doubleValue ), zoom: zoomlevel)
        self.clear()
        
        zoomLevel = zoomlevel
    }
    func setMapPosition (with displyHomes: DisplayHomeModel?, zoomlevel: Float = 12.0) {
        
        var lati = "0"
        var longi = "0"
        
        if let reg = displyHomes {
            if let lat = reg.latitude {
                if lat.count > 0 {
                    lati = reg.latitude!
                    longi = reg.longitude!
                }
            }
        }
        
        self.camera = GMSCameraPosition (target: CLLocationCoordinate2D (latitude: (lati as NSString).doubleValue, longitude: (longi as NSString).doubleValue ), zoom: zoomlevel)
        self.clear()
        
        zoomLevel = zoomlevel
    }
    func setMapPosition (with displyHomes: designLocations?, zoomlevel: Float = 12.0) {
        
        var lati = "0"
        var longi = "0"
        
        if let reg = displyHomes {
            if let lat = reg.latitude {
                if lat.count > 0 {
                    lati = reg.latitude!
                    longi = reg.longitude!
                }
            }
        }
        
        self.camera = GMSCameraPosition (target: CLLocationCoordinate2D (latitude: (lati as NSString).doubleValue, longitude: (longi as NSString).doubleValue ), zoom: zoomlevel)
        self.clear()
        
        zoomLevel = zoomlevel
    }
  
    func addMarkersToDesignLoc (packages: [designLocations]) {
        
        removeAllMarkers()
        
        for package in packages {
            
//            print(log: "latitude: \(package.latitude ?? "")")
//            print(log: "longitude: \(package.longitude ?? "")")
            
            if let lat = package.latitude {
                if lat.count > 0 {
                    let marker = designLocationMark (package: package)
                    marker.selected = true
                    marker.map = self
                    
                    designLocationMarkers.append(marker)
                }
            }
        }
    }
    
    
    func addMarkers (packages: [HomeLandPackage]) {
        
        removeAllMarkers()
        
        for package in packages {
//
//            print(log: "latitude: \(package.latitude ?? "")")
//            print(log: "longitude: \(package.longitude ?? "")")
            
            if let lat = package.latitude {
                if lat.count > 0 {
                    let marker = MyPlaceMarker (package: package)
                    marker.selected = true
                    marker.map = self
                    
                    allMarkers.append(marker)
                }
            }
        }
    }
    
    func addMarkersTONearByPlaces (nearByPlaces: [DisplayHomeModel]) -> [GMSMarker] {

        removeAllMarkers1()

        for nearByPlace in nearByPlaces {

//            print(log: "latitude: \(nearByPlace.latitude ?? "")")
//            print(log: "longitude: \(nearByPlace.longitude ?? "")")

            if let lat = nearByPlace.latitude {
                if lat.count > 0 {
                    let marker = NearByPlaceMarkers (nearByPlace: nearByPlace)
                    marker.selected = false
                    marker.map = self

                    NearByallMarkers.append(marker)
                }
            }
        }
        return NearByallMarkers
   
       
    }
    
    func removeAllMarkers () {
        for marker in allMarkers {
            marker.map = nil
        }
        
        allMarkers.removeAll()
    }
    
    func removeAllMarkers1 () {
        for marker in NearByallMarkers {
            marker.map = nil
        }
        
        NearByallMarkers.removeAll()
    }
    func removeAllMarkers2 () {
        for marker in designLocationMarkers {
            marker.map = nil
        }
        
        designLocationMarkers.removeAll()
    }
    
    //MARK: - Actions
    
    @IBAction func handleZoomButtons (_ sender: UIButton) {
        
        if sender == btnZoomIn {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_zoomIn_button_touch)
            
            if (zoomLevel + 1) <= maxZoom {
                
                zoomLevel = zoomLevel + 1
                
                self.animate(toZoom: zoomLevel)
            }
        }else {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_zoomOut_button_touch)
            
            if (zoomLevel - 1) >= minZoom {
                
                zoomLevel = zoomLevel - 1
                
                self.animate(toZoom: zoomLevel)
            }
        }
        
    }
    
}






class MyPlaceMarker: GMSMarker {
    
    let homeLandPackage: HomeLandPackage?
    
    var selected: Bool? {
        didSet {
            if selected == false {
                self.icon = UIImage (named: "Ico-LocationDot")
            }else {
                icon = UIImage (named: "Ico-Location-2")
            }
        }
    }
    
    
    init(package: HomeLandPackage) {
        homeLandPackage = package
        super.init()
        
        position = CLLocationCoordinate2D (latitude: (package.latitude! as NSString).doubleValue, longitude: (package.longitude! as NSString).doubleValue)
        
        selected = false
        
        icon = UIImage (named: "Ico-LocationDot")
    }
    
    

    
}

class designLocationMark: GMSMarker {
    
    let designLocationData: designLocations?
    
    var selected: Bool? {
        didSet {
            if selected == false {
                self.icon = UIImage (named: "Ico-LocationDot")
            }else {
                icon = UIImage (named: "Ico-Location-2")
            }
        }
    }
    
    
    init(package: designLocations) {
        designLocationData = package
        super.init()
        
        position = CLLocationCoordinate2D (latitude: (package.latitude! as NSString).doubleValue, longitude: (package.longitude! as NSString).doubleValue)
        
        selected = false
        
        icon = UIImage (named: "Ico-LocationDot")
    }
    
    

    
}
class NearByPlaceMarkers : GMSMarker{
    let displayHomesPlaces: DisplayHomeModel?
    
    var selected: Bool? {
        didSet {
            if selected == false {
                self.icon = UIImage (named: "Ico-LocationDot")
            }else {
                icon = UIImage (named: "Ico-Location-2")
            }
        }
    }
    
    init(nearByPlace: DisplayHomeModel) {
        displayHomesPlaces = nearByPlace
        super.init()
        
        position = CLLocationCoordinate2D (latitude: (nearByPlace.latitude! as NSString).doubleValue, longitude: (nearByPlace.longitude! as NSString).doubleValue)
        
        selected = false
        
        icon = UIImage (named: "Ico-LocationDot")
    }
    
}


class POIItem: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var homeLandPackage: HomeLandPackage
    
    var selected: Bool = false
    
    
    
    init(position: CLLocationCoordinate2D, name: String, package: HomeLandPackage) {
        self.position = position
        self.name = name
        
        self.homeLandPackage = package
    }
}
class POIItemTwo: NSObject, GMUClusterItem {
    var position: CLLocationCoordinate2D
    var name: String!
    var dispalyeNearByPlace: DisplayHomeModel
    
    var selected: Bool = false
    
    
    
    init(position: CLLocationCoordinate2D, name: String, package: DisplayHomeModel) {
        self.position = position
        self.name = name
        
        self.dispalyeNearByPlace = package
    }
}



