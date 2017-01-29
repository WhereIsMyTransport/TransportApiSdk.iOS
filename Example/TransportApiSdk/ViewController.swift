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

    let clientId = "10b8dfd8-9844-4e57-a510-e17868e58bea"
    let clientSecret = "7yHZX4zlefnM7wlW2G+KAnRPk2T5X3xUYpZyOhalhu0="
    
    var transportApiClient: TransportApiClient!
    
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func requestButton(_ sender: UIButton) {
        let startLocation = CLLocationCoordinate2D(latitude: -25.760938159763594, longitude: 28.23760986328125)
        let endLocation = CLLocationCoordinate2D(latitude: -26.02655312878948, longitude: 28.124313354492184)
        let onlyMode = [TransportMode.Rail]
        //let onlyAgencies = [""]
        
        self.resultTextView.text = "Something amazing is about to happen..."
        
        self.transportApiClient.PostJourney(onlyModes: onlyMode, startLocation: startLocation, endLocation: endLocation)
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

