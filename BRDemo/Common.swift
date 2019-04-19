//
//  Common.swift
//  BRDemo
//
//  Created by TAPAN BISWAS on 4/17/19.
//  Copyright © 2019 TAPAN BISWAS. All rights reserved.
//

import Foundation
import UIKit

//All Common functions and Global Variables
var imageCache: [Int: UIImage?] = [:]    //Holds images for cell backgrounds
var dataSet: Restaurants?                //Holds the restaurent dataset retrieved from remote URL

public struct Constants {
    static let isIPhone : Bool = (UIDevice.current.model == "iPhone")
    static let isIPad : Bool = (UIDevice.current.model == "iPad")
}

public func showModalMapView(_ presentingViewController: UIViewController, _ data: Any?) {
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let mapVC = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
    
    mapVC.modalPresentationStyle = .formSheet
    mapVC.modalTransitionStyle = .crossDissolve
    mapVC.dataSet = data as? Restaurants
    
    presentingViewController.present(mapVC, animated: true, completion: nil)
}
