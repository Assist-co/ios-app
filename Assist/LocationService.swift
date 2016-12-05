//
//  LocationService.swift
//  Assist
//
//  Created by christopher ketant on 12/3/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import MapKit

class LocationService: NSObject {
    static let sharedInstance = LocationService()
    let locationManager = CLLocationManager()
    fileprivate var userRegion: MKCoordinateRegion?
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.requestUserLocation()
    }
    
    func requestUserLocation(){
        self.locationManager.requestLocation()
    }
    
    //MARK:- Search
    
    func searchLocationsWith(text: String, completion: @escaping ([MKMapItem]) -> ()){
        let request = MKLocalSearchRequest()
        let region: MKCoordinateRegion?
        request.naturalLanguageQuery = text
        if let userRegion = self.userRegion {
            region = userRegion
        }else{
            region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(37.773972, -122.431297),
                                                            160934,160934)
        }
        request.region = region!
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                completion([])
                return
            }
            completion(response.mapItems)
        }
    }
    
    func locationsNearMe(completion: @escaping ([MKMapItem]) -> ()){
        let request = MKLocalSearchRequest()
        let region: MKCoordinateRegion?
        request.naturalLanguageQuery = "Coffee Shop"
        if let userRegion = self.userRegion {
            region = userRegion
        }else{
            region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(37.773972, -122.431297),
                                                            0,0)
        }
        request.region = region!
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                completion([])
                return
            }
            completion(response.mapItems)
        }
    }
    
}


extension LocationService : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            self.locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.first != nil {
            let coor = locations.first?.coordinate
            self.userRegion = MKCoordinateRegionMakeWithDistance(coor!, 25,25)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Enable the location for xcode")
    }
}
