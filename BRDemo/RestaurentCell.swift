//
//  RestaurentCell.swift
//  BRDemo
//
//  Created by Tapan Biswas on 4/17/19.
//  Copyright © 2019 TAPAN BISWAS. All rights reserved.
//

import UIKit

class RestaurentCell: UICollectionViewCell {
    
    // MARK: - Private Variables
    var backgroundImageURL: String?
    
    @IBOutlet weak var restaurentName: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var formattedAddress: String?
    var formattedPhone: String?
    var twitterHandle: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(name: String, category: String, imageURL: String) {
        self.init()
        
        self.restaurentName.text = name
        self.category.text = category
        self.backgroundImageURL = imageURL
    }
    
    // MARK: - Class Methods
    // Get background image from remote URL
    func getImageFromCache(_ index: Int) {
        
        // Load images from cache, if available. Else show spinner
        if imageCache[index] != nil {
            if self.spinner.isAnimating {
                self.spinner.stopAnimating()
            }
            self.backgroundView = UIImageView(image: imageCache[index]!)
            self.setNeedsDisplay()
            return
        } else {
            if !self.spinner.isAnimating {
                self.spinner.startAnimating()
            }
        }
    }

}
