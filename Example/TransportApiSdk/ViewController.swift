//
//  ViewController.swift
//  TransportApiSdk
//
//  Created by Chris on 01/24/2017.
//  Copyright (c) 2017 Bilo. All rights reserved.
//

import UIKit
import TransportApiSdk
import CoreLocation

class ViewController: UIViewController {

    // To get access credentials go to https://developer.whereismytransport.com
    let clientId = "YOUR_CLIENT_ID"
    let clientSecret = "YOUR_SECRET"
    
    var transportApiClient: TransportApiClient!
    
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func requestButton(_ sender: UIButton) {
        let exclude = "geometry,directions,distance"
        let startLocation = CLLocationCoordinate2D(latitude: -25.760938159763594, longitude: 28.23760986328125)
        let endLocation = CLLocationCoordinate2D(latitude: -26.02655312878948, longitude: 28.124313354492184)
        let onlyMode = [TransportMode.Rail]
        //let onlyAgencies = [""]
        
        self.resultTextView.text = "Something amazing is about to happen..."
        
        self.transportApiClient.PostJourney(onlyModes: onlyMode, excludes: exclude, startLocation: startLocation, endLocation: endLocation)
        {
            (result: TransportApiResult<Journey>) in
                DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transportApiClientSettings = TransportApiClientSettings(clientId: clientId, clientSecret: clientSecret)
        
        transportApiClient = TransportApiClient(transportApiClientSettings: transportApiClientSettings)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

