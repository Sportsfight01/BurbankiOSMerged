//
//  DisplaysRegionsMapVC.swift
//  BurbankApp
//
//  Created by sreekanth reddy Tadi on 05/05/21.
//  Copyright © 2021 Sreekanth tadi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import GoogleMaps
import GoogleMapsUtils
import GoogleUtilities


class DisplaysRegionsMapVC: UIViewController {
    var getDisplayNearByHome = [DisplayHomeModel]()
//    var homelandPopUpVc: HomeLandPopupVC?
    var markerInfoVC: MarkerInfoVC?
    var selectedMarker : NearByPlaceMarkers?
    private var clusterManager: GMUClusterManager!

    var homelandPopUpVc: HomeLandPopupVC?
    
    var regionsMapDetailsVC: DisplaysRegionsMapDetailVC?
    var selectedDisplayHomesDetails = [DisplayHomeModel]()
    
    @IBOutlet weak var mapView: MyPlaceMap!
    
    var selectedRegionForMaps: RegionMyPlace = RegionMyPlace.init()
    //MARK: - ViewLifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print(selectedRegionForMaps)

        DashboardDataManagement.shared.getDisplaysForRegionAndMap(stateId: kUserState, regionName: selectedRegionForMaps.regionName, popularFlag: true, userId: kUserID, showActivity: true) { (nearbyPlaces) in
            print(nearbyPlaces!)
            for package : NSDictionary  in nearbyPlaces! {
                
                let suggestedData = DisplayHomeModel(package as! [String : Any])
                if let region = suggestedData.regionName {
                    print(log: region.lowercased())
                    self.getDisplayNearByHome.append(suggestedData)
                }
                DispatchQueue.main.async {
                    self.mapView.delegate = self
                    self.mapView.setMapPosition(with: suggestedData, zoomlevel: 10.0)
                    let markars = self.mapView.addMarkersTONearByPlaces (nearByPlaces: self.getDisplayNearByHome)
                     
                     var bounds = GMSCoordinateBounds()
                         for marker in markars {
                             bounds = bounds.includingCoordinate(marker.position)
                         }
                     self.mapView.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 50.0 , left: 50.0 ,bottom: 50.0 ,right: 50.0)))
//                    self.generateClusterItems ()
                }
            }
    }
        mapView.addZoomLevelButtons ()
//        setUpClustering ()
        mapView.isMyLocationEnabled = true
        NotificationCenter.default.addObserver(forName: NSNotification.Name("handleBackBtnNaviogation"), object: nil, queue: nil, using:updatedNotification)
        
    }
    
    
    func updatedNotification(notification:Notification) -> Void  {
        self.navigationController?.popViewController(animated: true)
    }
    
   
    
}
// MARK: - Map Delegates And Clusters
extension DisplaysRegionsMapVC: GMSMapViewDelegate, UIPopoverPresentationControllerDelegate, GMUClusterManagerDelegate, GMUClusterRendererDelegate {
    
    func setUpClustering () {
        
        let iconGenerator = GMUDefaultClusterIconGenerator (buckets: [100], backgroundImages: [UIImage (named: "Ico-LocationDot")!])
        
        let algorithm = GMUNonHierarchicalDistanceBasedAlgorithm()
        let renderer = GMUDefaultClusterRenderer(mapView: mapView, clusterIconGenerator: iconGenerator)
        renderer.delegate = self
        
        clusterManager = GMUClusterManager(map: mapView, algorithm: algorithm, renderer: renderer)

        
        // Generate and add random items to the cluster manager.
//        generateClusterItems ()

        // Call cluster() after items have been added to perform the clustering
        // and rendering on map.
//        clusterManager.cluster()
        
        
        clusterManager.setDelegate(self, mapDelegate: self)
    }
    
    
    private func generateClusterItems() {
        let extent = 0.002
        
        if getDisplayNearByHome.count > 0 {
            
            let package = getDisplayNearByHome[0]
            self.mapView.setMapPosition(with: package)
            
            
            for index in 0...getDisplayNearByHome.count-1 {
                
                let homeLand = getDisplayNearByHome[index]
                
                if let latLangs = homeLand.latitude {
                    if latLangs.count > 0 {
                        let lat = (latLangs as NSString).doubleValue + extent * randomScale()
                        let lng = (homeLand.longitude! as NSString).doubleValue + extent * randomScale()
                        let name = "Item \(index)"
                        let item = POIItemTwo(position: CLLocationCoordinate2DMake(lat, lng), name: name, package: homeLand)
                         print("=-=-=--=--=-",item)
                        clusterManager.add (item)
                    }
                }
            }
            
            clusterManager.cluster()
        }
    }

    /// Returns a random value between -1.0 and 1.0.
    private func randomScale() -> Double {
        return Double(arc4random()) / Double(UINT32_MAX) * 2.0 - 1.0
    }
    
    
    
    
    func renderer(_ renderer: GMUClusterRenderer, markerFor object: Any) -> GMSMarker? {
        
        if (object as AnyObject).isKind(of: POIItemTwo.self) {
//        if (object as AnyObject).isKind(of: HomeLandPackage.self) {
            
            let markerMyPlace = NearByPlaceMarkers (nearByPlace: (object as! POIItemTwo).dispalyeNearByPlace)
            
            return markerMyPlace
        }
        
        return nil
    }
    
    func renderer(_ renderer: GMUClusterRenderer, willRenderMarker marker: GMSMarker) {
        
        print ("willRenderMarker")
    }
    
    func renderer(_ renderer: GMUClusterRenderer, didRenderMarker marker: GMSMarker) {
        
        print("didRenderMarker \(marker)")
    }
    
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if marker.isKind(of: NearByPlaceMarkers.self) {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_markers_button_touch)
            
            print(log: "zoomLevel \((mapView as! MyPlaceMap).zoomLevel)")
            
            makeAllMarkersasUnSelected ()
            
            selectedMarker = marker as? NearByPlaceMarkers
            selectedMarker?.selected = true
            
            
            let package = (marker as! NearByPlaceMarkers).displayHomesPlaces!
            self.regionsMapDetailsVC?.selectedDisplayHomes = package
            self.selectedDisplayHomesDetails.append(package)
//            self.selectedDisplayHomesDetails = package
            self.performSegue(withIdentifier: "DisplaysRegionsMapDetailVC", sender: nil)
            
        }else if let cluster = marker.userData as? GMUStaticCluster {
            
            CodeManager.sharedInstance.sendScreenName(burbank_homeAndLand_map_cluster_button_touch)
//            self.regionsMapDetailsVC?.arrDisplayHomes.removeAll()
            
            for item in cluster.items as! [POIItemTwo] {
                self.selectedDisplayHomesDetails.append(item.dispalyeNearByPlace)
//                self.regionsMapDetailsVC?.arrDisplayHomes?.append(item.dispalyeNearByPlace)
            }
            self.performSegue(withIdentifier: "DisplaysRegionsMapDetailVC", sender: nil)
            
        }

        return true
    }
    

    private func clusterManager(clusterManager: GMUClusterManager, didTapCluster cluster: GMUCluster) {
        print("cluster tap")
      }


    
    func makeAllMarkersasUnSelected () {
        if let marker = selectedMarker {
            marker.selected = false
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        mapView.isMyLocationEnabled = true
    }
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print(log: "Error \(error)")
    }
    
    
   
}
// MARK: - Handling Button Actions and Segues

extension DisplaysRegionsMapVC{
    
    @IBAction func handleButtonActions (_ sender: UIButton) {

        self.performSegue(withIdentifier: "DisplaysRegionsVC", sender: sender)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DisplaysRegionsMapDetailVC" {
            regionsMapDetailsVC?.arrDisplayHomes = self.selectedDisplayHomesDetails
            regionsMapDetailsVC = segue.destination as? DisplaysRegionsMapDetailVC
            
        }
    }
    
}

