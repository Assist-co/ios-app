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
        request.naturalLanguageQuery = text
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
        request.naturalLanguageQuery = "San Francisco"
        if let region = self.userRegion{
            request.region = region
            let search = MKLocalSearch(request: request)
            search.start { response, _ in
                guard let response = response else {
                    completion([])
                    return
                }
                completion(response.mapItems)
            }
        }else{
            completion([])
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
            let span = MKCoordinateSpan(latitudeDelta: 10000,longitudeDelta: -10000)
            self.userRegion = MKCoordinateRegion(center: coor!, span: span)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Enable the location for xcode")
    }
}
