//
//  LunchDetailViewController.swift
//  BRDemo
//
//  Created by TAPAN BISWAS on 4/17/19.
//  Copyright © 2019 TAPAN BISWAS. All rights reserved.
//

import UIKit
import MapKit

class LunchDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var restaurentName: UILabel!
    @IBOutlet weak var restaurentCategory: UILabel!
    @IBOutlet weak var restaurentAddress: UILabel!
    @IBOutlet weak var restaurentPhone: UILabel!
    @IBOutlet weak var twitterHandle: UILabel!
    @IBOutlet weak var mapHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleBandView: UIView!
    @IBOutlet weak var addressView: UIView!
    
    // MARK: - Private Variables
    var restaurent: Restaurant!     //Set by calling View Controller
    
    // MARK: - View Life-cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View with Navigation BarItems
        setupViewControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Initialize outlets with values passed
        restaurentName.text = restaurent.name
        restaurentCategory.text = restaurent.category
        restaurentAddress.text = restaurent.location?.formattedAddress?.joined(separator: "\n")
        restaurentPhone.text = restaurent.contact?.formattedPhone
        twitterHandle.text = restaurent.contact?.twitter != nil ? ("@" + (restaurent.contact?.twitter)!) : ""
        
        // Set Map features and coordinates
        let resLocation = CLLocationCoordinate2DMake((restaurent?.location?.lat)!, (restaurent?.location?.lng)!)
        let locSpan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
        mapView.setCenter(resLocation, animated: true)
        mapView.setRegion(MKCoordinateRegion(center: resLocation, span: locSpan), animated: true)
    }
    
    // MARK: - Private Methods
    
    // Setup view controls related to launch view
    private func setupViewControls() {
        
        //Set title
        self.title = "Lunch Tyme"
        
        //Setup Left and Right Bar Button Item and Action Methods
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "ic_webBack"), style: .done, target: self, action: #selector(goBack))
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "icon_map"), style: .done, target: self, action: #selector(mapButtonTapped))
        leftBarButton.tintColor = UIColor.white
        rightBarButton.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItem = leftBarButton
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        // Setup Map features
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsPointsOfInterest = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        
        // Add tap gesture to mapView to expand it when user taps on the map
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        tapGesture.numberOfTapsRequired = 1
        
        mapView.addGestureRecognizer(tapGesture)
    }

    @objc func mapTapped(sender: Any) {
        //Animate expand and collapse on tap
        if mapView.frame.height == 180 {
            UIView.animate(withDuration: 0.5, animations: {
                self.titleBandView.frame.origin = CGPoint(x: 0, y: self.view.frame.maxY - 320)
                self.addressView.frame.origin = CGPoint(x: 0, y: self.view.frame.maxY - 260)
                self.mapView.frame.origin = CGPoint(x: 0, y: 0)
                self.mapView.frame.size = CGSize(width: self.mapView.bounds.width, height: self.view.frame.maxY - 320)
            }) { (true) in
                self.mapHeightConstraint.constant = self.view.frame.maxY - 320
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.titleBandView.frame.origin = CGPoint(x: 0, y: 180)
                self.addressView.frame.origin = CGPoint(x: 0, y: 240)
                self.mapView.frame.origin = CGPoint(x: 0, y: 0)
                self.mapView.frame.size = CGSize(width: self.mapView.bounds.width, height: 180)
            }) { (true) in
                self.mapHeightConstraint.constant = 180
            }
        }
    }
    
    // Go Back to previous screen
    @objc private func goBack(sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func mapButtonTapped(sender: Any) {
        showModalMapView(self, dataSet)
    }
}
