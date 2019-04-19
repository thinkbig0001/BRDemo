//
//  MapViewController.swift
//  BRDemo
//
//  Created by TAPAN BISWAS on 4/17/19.
//  Copyright © 2019 TAPAN BISWAS. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Private Variables
    var dataSet: Restaurants!
    
    // MARK: - View Life-cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View with Navigation BarItems
        setupViewControls()
    }
    
    // MARK: - Private Methods
    
    // Setup view controls related to launch view
    private func setupViewControls() {
        //Make sure close button is on the top of map view.
        view.bringSubviewToFront(closeButton)
        closeButton.backgroundColor = UIColor.lightGray
        
        //Initialize mapView features
        mapView.isZoomEnabled = true
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsPointsOfInterest = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        
        //Add action to close button
        closeButton.addTarget(self, action: #selector(closeWindow), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Add location annotation for all restaurents
        var annotations: [MKAnnotation] = []
        
        dataSet?.restaurantList.forEach({ (restaurent) in
            if let latitude = restaurent.location?.lat, let longitude = restaurent.location?.lng {
                let locationCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = locationCoordinate
                annotation.title = restaurent.name
                annotations.append(annotation)
            }
        })
        
        mapView.showAnnotations(annotations, animated: true)
    }
    
    @objc private func closeWindow(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
