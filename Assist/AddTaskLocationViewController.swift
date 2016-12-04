//
//  TaskInfoOptionsViewController.swift
//  Assist
//
//  Created by christopher ketant on 12/3/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit
import MapKit

class AddTaskLocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vcTitleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    fileprivate var isFiltering: Bool = false
    fileprivate var filteredItems: [MKMapItem] = []
    weak var taskInfoDelegate: TaskInfoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
    }
    
    //MARK:- UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let mapItem = self.filteredItems[indexPath.row]
        self.taskInfoDelegate?.addLocation(mapItem: mapItem)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- UITableViewDatasource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as UITableViewCell
        let mapItem = self.filteredItems[indexPath.row]
        let placemark = mapItem.placemark
        var address = ""
        if placemark.subThoroughfare != nil{
            address += placemark.subThoroughfare!
        }
        if placemark.thoroughfare != nil{
            address += placemark.thoroughfare!
            address += ", "
        }
        if placemark.locality != nil{
            address += " "
            address += placemark.locality!
        }
        cell.textLabel?.text = mapItem.placemark.name
        cell.detailTextLabel?.text = address
        return cell
    }
    
    //MARK:- Actions
    
    @IBAction func cancel(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Utils
    
    fileprivate func setup(){
        self.searchBar.placeholder = "Search Location"
        LocationService.sharedInstance.requestUserLocation()
        self.searchBar.becomeFirstResponder()
        LocationService.sharedInstance.locationsNearMe(completion: { (mapItems: [MKMapItem]) in
            self.filteredItems = mapItems
            self.tableView.reloadData()
        })
    }
        
}

// SearchBar methods
extension AddTaskLocationViewController: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        self.isFiltering = true
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        self.isFiltering = false
        self.tableView.reloadData()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.filteredItems = []
            self.tableView.reloadData()
        }else{
            LocationService.sharedInstance.searchLocationsWith(text: searchText, completion: { (mapItems: [MKMapItem]) in
                self.filteredItems = mapItems
                self.tableView.reloadData()
            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
