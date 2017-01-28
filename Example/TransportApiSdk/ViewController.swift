//
//  ViewController.swift
//  TransportApiSdk
//
//  Created by Bilo on 01/24/2017.
//  Copyright (c) 2017 Bilo. All rights reserved.
//

import UIKit
import TransportApiSdk
import CoreLocation

class ViewController: UIViewController {

    var isBlinking = false
    let blinkingLabel = BlinkingLabel(frame: CGRect(x: 10, y: 20, width: 200, height: 30))
    let transportApiClientSettings = TransportApiClientSettings(clientId: "10b8dfd8-9844-4e57-a510-e17868e58bea", clientSecret: "7yHZX4zlefnM7wlW2G+KAnRPk2T5X3xUYpZyOhalhu0=")
    var transportApiClient: TransportApiClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        transportApiClient = TransportApiClient(transportApiClientSettings: transportApiClientSettings)
        
        // Setup the BlinkingLabel
        blinkingLabel.text = "Bla"
        blinkingLabel.font = UIFont.systemFont(ofSize: 20)
        view.addSubview(blinkingLabel)
        blinkingLabel.startBlinking()
        isBlinking = true
        
        // Create a UIButton to toggle the blinking
        let toggleButton = UIButton(frame: CGRect(x: 10, y: 60, width: 125, height: 30))
        toggleButton.setTitle("Toggle Blinking", for: .normal)
        toggleButton.setTitleColor(UIColor.red, for: .normal)
        toggleButton.addTarget(self, action: #selector(ViewController.toggleBlinking), for: .touchUpInside)
        view.addSubview(toggleButton)
        
    }
    
    func toggleBlinking() {
        if (isBlinking) {
            blinkingLabel.stopBlinking()
            
            /*let d = Date()
            
            self.transportApiClient.GetAgencies(at: d)
            {
                (result: TransportApiResult<[Agency]>) in
                print(result)
            }*/
            let startLocation = CLLocationCoordinate2D(latitude: -25.760938159763594, longitude: 28.23760986328125)
            let endLocation = CLLocationCoordinate2D(latitude: -26.02655312878948, longitude: 28.124313354492184)
            
            self.transportApiClient.PostJourney(startLocation: startLocation, endLocation: endLocation)
            {
                (result: TransportApiResult<Journey>) in
                print(result)
            }
        } else {
            blinkingLabel.startBlinking()
            
            self.transportApiClient.GetAgencies
                {
                (result: TransportApiResult<[Agency]>) in
                print(result)
            }
        }
        isBlinking = !isBlinking
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

