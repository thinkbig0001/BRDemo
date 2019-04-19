//
//  InternetViewController.swift
//  BRDemo
//
//  Created by TAPAN BISWAS on 4/16/19.
//  Copyright © 2019 TAPAN BISWAS. All rights reserved.
//

import UIKit
import WebKit

class InternetViewController: UIViewController {

    // MARK: - Private Variables
    
    var webView: WKWebView!
    var webNavigation: WKNavigation!
    
    // MARK: - View Life-cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup View with Navigation BarItems
        setupViewControls()
        
        // Load Initial Web Page
        loadInitialWebPage()
    }
    

    // MARK: - Private Methods
    
    // Setup view controls related to launch view
    private func setupViewControls() {
        
        //Setup Back, Refresh and Next Bar Button Items and Action Methods
        let backBarButton = UIBarButtonItem(image: UIImage(named: "ic_webBack"), style: .plain, target: self, action: #selector(navigateBack))
        
        let forwardBarButton = UIBarButtonItem(image: UIImage(named: "ic_webForward"), style: .plain, target: self, action: #selector(navigateForward))
        
        let refreshBarButton = UIBarButtonItem(image: UIImage(named: "ic_webRefresh"), style: .plain, target: self, action: #selector(refreshPage))
        
        //Set button tint color as required
        backBarButton.tintColor = UIColor.white
        forwardBarButton.tintColor = UIColor.white
        refreshBarButton.tintColor = UIColor.white
        
        self.navigationItem.leftBarButtonItems = [backBarButton, refreshBarButton, forwardBarButton]
    }
    
    // Load initial web page
    private func loadInitialWebPage() {
        guard let initialPageURL = URL(string: "https://www.bottlerocketstudios.com") else { return }
        let pageRequest = URLRequest(url: initialPageURL)
        webView.load(pageRequest)
    }
    
    // MARK: - Action Methods
    @objc private func navigateBack(sender: Any) {
        webView.goBack()
    }
    
    @objc private func navigateForward(sender: Any) {
        webView.goForward()
    }

    @objc private func refreshPage(sender: Any) {
        webView.reload()
    }

}

extension InternetViewController: WKUIDelegate {
    
    // MARK: - Delegate methods
    override func loadView() {
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect.zero, configuration: webConfig)
        webView.uiDelegate = self
        self.view = webView
    }
    
}
