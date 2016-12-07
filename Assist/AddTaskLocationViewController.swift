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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIButton!
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchBar.becomeFirstResponder()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath) as! SearchResultTableViewCell
        let mapItem = self.filteredItems[indexPath.row]
        let placemark = mapItem.placemark
        var address = ""
        if placemark.subThoroughfare != nil{
            address += placemark.subThoroughfare!
            address += " "
        }
        if placemark.thoroughfare != nil{
            address += placemark.thoroughfare!
            address += ", "
        }
        if placemark.locality != nil{
            address += " "
            address += placemark.locality!
        }
        cell.title.text = mapItem.placemark.name
        cell.subTitle.text = address
        return cell
    }
    
    //MARK:- Actions
    
    @IBAction func cancel(button: UIButton) {
        self.searchBar.resignFirstResponder()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Utils
    
    fileprivate func setup(){
        self.searchBar.tintColor = UIColor.white
        self.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        self.searchBar.placeholder = "Search Location"
        LocationService.sharedInstance.requestUserLocation()
        self.searchingState(isSpinning: true)
        LocationService.sharedInstance.locationsNearMe(completion: { (mapItems: [MKMapItem]) in
            self.filteredItems = mapItems
            self.tableView.reloadData()
            self.searchingState(isSpinning: false)
        })
    }
    
    fileprivate func searchingState(isSpinning: Bool){
        if isSpinning {
            self.cancelButton.isEnabled = false
            self.spinner.startAnimating()
            self.spinner.isHidden = false
        }else{
            self.cancelButton.isEnabled = true
            self.spinner.stopAnimating()
        }
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
