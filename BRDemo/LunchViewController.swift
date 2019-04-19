//
//  LunchViewController.swift
//  BRDemo
//
//  Created by TAPAN BISWAS on 4/16/19.
//  Copyright © 2019 TAPAN BISWAS. All rights reserved.
//

import UIKit

class LunchViewController: UIViewController {
    
    // MARK: - Storyboard Outlets
    @IBOutlet weak var resCollection: UICollectionView!
    
    // MARK: - Private Variables
    var selectedIndexPath: IndexPath!   //Holds the IndexPath of the item selected in collection view
    
    // MARK: - View Life-cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View with Navigation BarItems
        setupViewControls()
        
        // Initiate Async Remote Data Load
        loadRemoteData()
        
        // Initialize Collection View Cells
        resCollection.reloadData()
        
        //Set tab bar height
        var tabBarRect = self.tabBarController?.tabBar.frame
        tabBarRect?.origin = CGPoint(x: self.view.frame.minX, y: self.view.frame.maxY - 50)
        tabBarRect?.size = CGSize(width: self.view.frame.width, height: 50)
        tabBarController?.tabBar.frame = tabBarRect!
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        resCollection.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }

    // MARK: - Private Methods
    
    // Setup view controls related to launch view
    private func setupViewControls() {
        
        //Setup Right Bar Button Item and Action Method
        let rightBarButton = UIBarButtonItem(image: UIImage(named: "icon_map"), style: .done, target: self, action: #selector(mapButtonTapped))
        rightBarButton.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        //Set Delegate for CollectionView
        resCollection.delegate = self
        resCollection.dataSource = self
        
        resCollection.allowsMultipleSelection = false
    }
    
    // Load Remote Data
    private func loadRemoteData() {
        guard let remoteURL = URL(string: "https://s3.amazonaws.com/br-codingexams/restaurants.json") else { return }
        
        let request = URLRequest(url: remoteURL)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //Handle Error
            if error != nil {
                print("Error: Failed to load data\n \(error?.localizedDescription)\n")
                return
            }
            
            //Handle Response Code for HTTP request
            if let httpResponse = response as? HTTPURLResponse {
                print("Response Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 { return }
            }
            
            //Handle Data received (not nil)
            if let responseData = data {
                do {
                    // Decode JSON data
                    dataSet = try JSONDecoder().decode(Restaurants.self, from: responseData)
                    
                    if (dataSet?.restaurantList.count ?? 0) > 0 {
                        self.loadImagesIntoCache()
                    }
                    // Reload collection view cell
                    OperationQueue.main.addOperation {
                        self.resCollection.reloadData()
                    }                    
                } catch {
                    print("Error: Failed to convert data received into native format")
                    return
                }
            }
        }
        
        task.resume()
        
    }
    
    private func loadImagesIntoCache() {
        guard let countOfRestaurants = dataSet?.restaurantList.count else { return }
        
        if countOfRestaurants == 0 { return } // If list is empty - return
            
        for index in 0..<countOfRestaurants {
            let imageURL = URL(string: dataSet?.restaurantList[index].backgroundImageURL ?? "")
            if imageURL != nil {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: imageURL!), let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            imageCache[index] = image
                            self.resCollection.reloadItems(at: [IndexPath(item: index, section: 0)])
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Action Methods
    
    @objc private func mapButtonTapped(sender: Any) {
        showModalMapView(self, dataSet)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is LunchDetailViewController {
            let destViewController = segue.destination as! LunchDetailViewController
            destViewController.restaurent = dataSet?.restaurantList[selectedIndexPath.row]
        }
    }

}

extension LunchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Delegate methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet?.restaurantList.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resCell", for: indexPath) as! RestaurentCell
        
        guard let restaurent = dataSet?.restaurantList[indexPath.row] else { return cell }
        
        cell.backgroundImageURL = restaurent.backgroundImageURL
        cell.restaurentName?.text = restaurent.name
        cell.category?.text = restaurent.category
        cell.backgroundView = UIImageView(image: UIImage(named: "cellGradientBackground"))
        cell.getImageFromCache(indexPath.row)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "resDetail", sender: self)
    }
}

extension LunchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let spacing = CGFloat(2)
        let cellWidth = view.frame.width
        let cellHeight = CGFloat(180)

        //For iPad only we show two columns
        if Constants.isIPad {
            return CGSize(width: (cellWidth - spacing) / 2, height: cellHeight)
        } else {
            return CGSize(width: cellWidth, height: cellHeight)
        }
    }
    
}
