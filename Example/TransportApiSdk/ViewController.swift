//
//  ViewController.swift
//  TransportApiSdk
//
//  Created by Chris on 01/24/2017.
//  Copyright (c) 2017 Chris. All rights reserved.
//

import UIKit
import TransportApiSdk
import CoreLocation

class ViewController: UIViewController {

    // To get access credentials go to https://developer.whereismytransport.com
    let clientId = "dafaba75-dd54-4c35-af04-c53e348e4837"
    let clientSecret = "z+ecIyHxXxsYzHCp4EmuBSUcu42BFkZcOk2n2NWdbas="
    
    var transportApiClient: TransportApiClient!
    
    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func requestButton(_ sender: UIButton) {
        //let exclude = "geometry,directions,distance"
        //let startLocation = CLLocationCoordinate2D(latitude: -25.760938159763594, longitude: 28.23760986328125)
        //let endLocation = CLLocationCoordinate2D(latitude: -26.02655312878948, longitude: 28.124313354492184)
        //let onlyMode = [TransportMode.Rail]
        //let onlyAgencies = [""]
        
        self.resultTextView.text = "Something amazing is about to happen..."
        
        /*self.transportApiClient.PostJourney(startLocation: startLocation, endLocation: endLocation)
        {
            (result: TransportApiResult<Journey>) in
                DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
                }
        }*/
        
        /*self.transportApiClient.GetJourney(id: "rHfzAvs4Rki3jKccAUoGYA")
        {
            (result: TransportApiResult<Journey>) in
            DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
            }
        }*/
        
        /*self.transportApiClient.GetAgencies()
        {
            (result: TransportApiResult<[Agency]>) in
            DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
            }
        }*/
        
        /*self.transportApiClient.GetAgency(id: "A1JHSPIg_kWV5XRHIepCLw")
            {
                (result: TransportApiResult<Agency>) in
                DispatchQueue.main.async
                    {
                        self.resultTextView.text = result.rawJson
                }
        }*/
        
        /*self.transportApiClient.GetStops()
        {
            (result: TransportApiResult<[Stop]>) in
            DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
            }
        }*/
        
        /*self.transportApiClient.GetStop(id: "S1twiBqUm0ul6ZMtCnfOcg")
        {
            (result: TransportApiResult<Stop>) in
            DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
            }
        }*/
        
        /*self.transportApiClient.GetLines()
         {
            (result: TransportApiResult<[Line]>) in
            DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
            }
         }
        
        self.transportApiClient.GetLine(id: "giwBPOBfeE-C4acZAI_7uQ")
         {
            (result: TransportApiResult<Line>) in
            DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
            }
         }*/
        
        /*self.transportApiClient.GetFareProducts()
            {
                (result: TransportApiResult<[FareProduct]>) in
                DispatchQueue.main.async
                    {
                        self.resultTextView.text = result.rawJson
                }
        }*/
        
        self.transportApiClient.GetFareProduct(id: "BQWEZcffgUGF52ah5E9kJQ")
        {
            (result: TransportApiResult<FareProduct>) in
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

