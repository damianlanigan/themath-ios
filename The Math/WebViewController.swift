//
//  WebViewController.swift
//  HowAmIDoing
//
//  Created by Michael Kavouras on 5/16/15.
//  Copyright (c) 2015 Mike Kavouras. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var url: NSURL!
    var navigationTitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.loadRequest(NSURLRequest(URL: url))
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = navigationTitle
    }

}
