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

    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func viewLogsButton(_ sender: UIButton) {
        let fileName = "GetOffLogs"
        let DocumentDirURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        
        let fileURL = DocumentDirURL.appendingPathComponent(fileName).appendingPathExtension("txt")
        // Read from the file
        var readString = "" // Used to store the file contents
        do {
            // Read the file contents
            readString = try String(contentsOf: fileURL)
        } catch let error as NSError {
            print("Failed reading from URL: \(fileURL), Error: " + error.localizedDescription)
        }
        print("File Text: \(readString)")
    }
    
    @IBAction func requestButton(_ sender: UIButton) {
        //let exclude = "geometry,directions,distance"
        let startLocation = CLLocationCoordinate2D(latitude: -33.921776, longitude: 18.425955)
        let endLocation = CLLocationCoordinate2D(latitude: -34.002589, longitude: 18.47108)
        let onlyMode = ["Rail"]
        //let onlyAgencies = [""]
        
        self.resultTextView.text = "Something amazing is about to happen..."
        
        TransportApiClient.postJourney(onlyModes: onlyMode, startLocation: startLocation, endLocation: endLocation, time: Date())
        {
            (result: TransportApiResult<Journey>) in
                DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
                }
        }
        
        /*self.transportApiClient.GetJourney(id: "Nef5Jhy-pk2LM6c4AO4ocw")
        {
            (result: TransportApiResult<Journey>) in
            DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
            }
        }*/
        
        /*TransportApiClient.getItinerary(journeyId: "rHfzAvs4Rki3jKccAUoGYA",
                                             itineraryId: "QIuuBAmdhU-mxaccAUoNRw")
         {
            (result: TransportApiResult<Itinerary>) in
         
         
            DispatchQueue.main.async
                {
                    _ = TransportApiClient.startMonitoringWhenToGetOff(itinerary: result.data)
                    
                    
                    //TransportApiClient.stopMonitoringWhenToGetOff()
            }
         }*/
        
        /*TransportApiClient.getAgencies()
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
        
        /*self.transportApiClient.GetStopTimetable(id: "S1twiBqUm0ul6ZMtCnfOcg")
        {
            (result: TransportApiResult<[StopTimetable]>) in
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
        
        /*self.transportApiClient.GetLineTimetable(id: "giwBPOBfeE-C4acZAI_7uQ")
        {
            (result: TransportApiResult<[LineTimetable]>) in
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
        
        /*self.transportApiClient.GetFareProduct(id: "BQWEZcffgUGF52ah5E9kJQ")
        {
            (result: TransportApiResult<FareProduct>) in
            DispatchQueue.main.async
                {
                    self.resultTextView.text = result.rawJson
            }
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

