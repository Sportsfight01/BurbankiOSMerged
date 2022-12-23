//
//  DirctionsVC.swift
//  BurbankApp
//
//  Created by Naveen Kourampalli on 18/06/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GoogleMapsUtils
import MapKit


class DirctionsVC: HeaderVC,GMSMapViewDelegate,MKMapViewDelegate {
  //    @IBOutlet weak var mapView: MyPlaceMap!
  
  @IBOutlet weak var backBtnView: UIView!
  var isFromFavorites : Bool = false
  @IBOutlet weak var displayDetailsCard: UIView!
  @IBOutlet weak var estateNameLBL: UILabel!
  @IBOutlet weak var mapView1: MKMapView!
  @IBOutlet weak var navTopConstraint: NSLayoutConstraint!
  
  
  var displayHomeData: [houseDetailsByHouseType]?
  //    {
  //
  //        didSet {
  //            fillAllDisplayHomeDetails()
  //        }
  //    }
  var estateName = ""
  var distinationLocation : CLLocationCoordinate2D?
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView1.delegate = self
    mapView1.showsUserLocation = true
    //        mapView.addZoomLevelButtons()
    LocationServices.shared.requestUsertoAllowLocationPermissions()
    LocationServices.shared.locationManager?.startUpdatingLocation()
    
    NotificationCenter.default.post(name: NSNotification.Name("changeBreadCrumbs"), object: nil, userInfo: ["breadcrumb" :"See one of our display homes"])
    
    if LocationServices.shared.isLocationServicesEnabled(){
      
    }else{
      LocationServices.shared.requestUsertoAllowLocationPermissions()
    }
    NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: locationupdated),
                                           object: nil,
                                           queue: nil,
                                           using:updatedNotification)
    
    
    
    //        self.estateNameLBL.text = displayHomeData
    let font:UIFont? = FONT_LABEL_HEADING(size: FONT_12)
    let fontSuper:UIFont? = FONT_LABEL_HEADING(size: FONT_11)
    let boldFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: font]
    let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: fontSuper]
    let partOne = NSMutableAttributedString(string: displayHomeData?[0].displayEstateName.uppercased() ?? "" , attributes: boldFontAttributes as [NSAttributedString.Key : Any])
    let partTwo = NSMutableAttributedString(string: "\n\(displayHomeData?[0].street ?? ""), \(displayHomeData?[0].suburb ?? "")", attributes: normalFontAttributes as [NSAttributedString.Key : Any])
    let combination = NSMutableAttributedString()
    combination.append(partOne)
    combination.append(partTwo)
    print(combination)
    self.estateNameLBL.attributedText = combination
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name("handleBackBtnNaviogation"), object: nil, queue: nil, using:updatedNotification1)
    
    if isFromFavorites{
      headerLogoText = "DisplayHomes"
        isFromProfile = true
    navTopConstraint.constant = 135
      backBtnView.isHidden = true
    self.addBreadCrumb(from: "Get Directions")
      if btnBack.isHidden {
          showBackButton()
          btnBack.addTarget(self, action: #selector(handleNavBackBtn), for: .touchUpInside)
          btnBackFull.addTarget(self, action: #selector(handleNavBackBtn), for: .touchUpInside)
      }
   //  headerLogoText = "Favorites"
    }else {
      backBtnView.isHidden = false
      navTopConstraint.constant = 0
      containerView?.isHidden = true
      headerView_header.isHidden = true
      headerViewHeight = 0
    
    }
    
  }
  @objc func handleNavBackBtn()
  {
    self.navigationController?.popViewController(animated: true)
  }
  func updatedNotification1(notification:Notification) -> Void  {
    self.navigationController?.popViewController(animated: true)
  }
  func updatedNotification(notification:Notification) -> Void {
    guard let location = notification.userInfo!["loc"] else { return }
    let locValue = location as! CLLocationCoordinate2D
    let lat = Double(displayHomeData?[0].latitude ?? "0.0")
    let long = Double(displayHomeData?[0].longitude ?? "0.0")!
    let startPoint = CLLocationCoordinate2D(latitude: locValue.latitude, longitude: locValue.longitude)
    let destination = CLLocationCoordinate2D(latitude:lat ?? 0.0, longitude: long ?? 0.0)
    
    
    
    
    //        let noLocation = CLLocationCoordinate2D()
//    let viewRegion = MKCoordinateRegion(center: locValue, latitudinalMeters: 200, longitudinalMeters: 200)
//    mapView1.setRegion(viewRegion, animated: false)
    mapView1.showsUserLocation = true
    
    let annonation = MKPointAnnotation()
    annonation.coordinate = destination
    annonation.title = "\(estateName)"
    annonation.subtitle = ""
    mapView1.addAnnotation(annonation)
    showRouteOnMap(pickupCoordinate: startPoint, destinationCoordinate: destination)
  }
  
  
  func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
    
    let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
    let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
    
    let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
    let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
    
    let sourceAnnotation = MKPointAnnotation()
    
    if let location = sourcePlacemark.location {
      sourceAnnotation.coordinate = location.coordinate
    }
    
    let destinationAnnotation = MKPointAnnotation()
    
    if let location = destinationPlacemark.location {
      destinationAnnotation.coordinate = location.coordinate
    }
    
    //        self.mapView1.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
    
    let directionRequest = MKDirections.Request()
    directionRequest.source = sourceMapItem
    directionRequest.destination = destinationMapItem
    directionRequest.transportType = .any
    
    // Calculate the direction
    let directions = MKDirections(request: directionRequest)
    
    directions.calculate {
      (response, error) -> Void in
      
      guard let response = response else {
        if let error = error {
          print("Error: \(error)")
        }
        
        return
      }
      
      let route = response.routes[0]
      
      self.mapView1.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
      
      var regionRect = route.polyline.boundingMapRect
      let wPadding = regionRect.size.width * 0.25
      let hPadding = regionRect.size.height * 0.25
      
      //Add padding to the region
      regionRect.size.width += wPadding
      regionRect.size.height += hPadding
      
      //Center the region on the line
      regionRect.origin.x -= wPadding / 2
      regionRect.origin.y -= hPadding / 2
      self.mapView1.setRegion( MKCoordinateRegion (regionRect), animated: true)
      //            self.mapView1.setRegion(MKCoordinateRegion(rect), animated: true)
    }
  }
  
  // MARK: - MKMapViewDelegate
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    
    let renderer = MKPolylineRenderer(overlay: overlay)
    
    renderer.strokeColor = .blue
    renderer.lineWidth = 3.0
    
    return renderer
  }
  
  
  func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    
    let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(self.distinationLocation?.latitude ?? 0.0),\(self.distinationLocation?.longitude ?? 0.0)&sensor=true&mode=driving&key=AIzaSyCMr5OI8HUQ30XAXg9_hcCORDUYOxm9uZ4")!
    
    print(url)
    let task = session.dataTask(with: url, completionHandler: {
      (data, response, error) in
      if error != nil {
        print(error!.localizedDescription)
      }
      else {
        do {
          if let json : [String:Any] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]{
            print(json)
            
            guard let routes = json["routes"] as? NSArray else {
              DispatchQueue.main.async {
                //                                    self.activityIndicator.stopAnimating()
              }
              return
            }
            
            if (routes.count > 0) {
              let overview_polyline = routes[0] as? NSDictionary
              let dictPolyline = overview_polyline?["overview_polyline"] as? NSDictionary
              
              let points = dictPolyline?.object(forKey: "points") as? String
              
              //  self.showPath(polyStr: points!)
              
              DispatchQueue.main.async {
                //                                    self.activityIndicator.stopAnimating()
                
                //                                    let bounds = GMSCoordinateBounds(coordinate: source, coordinate: destination)
                //                                    let update = GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 170, left: 30, bottom: 30, right: 30))
                //                                    self.mapView!.moveCamera(update)
              }
            }
            else {
              DispatchQueue.main.async {
                //                                    self.activityIndicator.stopAnimating()
              }
            }
          }
        }
        catch {
          print("error in JSONSerialization")
          DispatchQueue.main.async {
            //                            self.activityIndicator.stopAnimating()
          }
        }
      }
    })
    task.resume()
  }
  
  //        func showPath(polyStr :String){
  //            let path = GMSPath(fromEncodedPath: polyStr)
  //            let polyline = GMSPolyline(path: path)
  //            polyline.strokeWidth = 3.0
  //            polyline.strokeColor = UIColor.red
  //            polyline.map = mapView // Your map view
  //        }
  
  @IBAction func didTappedOnBackButton(_ sender: UIButton) {
    self.navigationController?.popViewController(animated: true)
    //        self.displayDetailsCard.isHidden = true
    
  }
  
  
  
  
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
