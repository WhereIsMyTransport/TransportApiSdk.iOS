//
//  TransportApi.swift
//  Pods
//
//  Created by Chris on 1/24/17.
//
//

import Foundation
import SwiftyJSON
import CoreLocation

public class TransportApiClient
{
    private let maxLimit = 100
    private let platformURL = "https://platform.whereismytransport.com/api/"
    
    private var transportApiClientSettings: TransportApiClientSettings
    private var tokenComponent: TokenComponent!
    
    public init(transportApiClientSettings: TransportApiClientSettings)
    {
        self.transportApiClientSettings = transportApiClientSettings
        self.tokenComponent = TokenComponent(transportApiClientSettings: transportApiClientSettings)
    }
    
    public func PostJourney(fareProducts: [String]! = nil,
                            onlyAgencies: [String]! = nil,
                            omitAgencies: [String]! = nil,
                            onlyModes: [TransportMode]! = nil,
                            omitModes: [TransportMode]! = nil,
                            startLocation: CLLocationCoordinate2D,
                            endLocation: CLLocationCoordinate2D,
                            time: Date = Date(),
                            timeType: TimeType = TimeType.DepartAfter,
                            profile: Profile = Profile.ClosestToTime,
                            maxItineraries: Int = 3,
                            completion: @escaping (_ result: TransportApiResult<Journey>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: String!) in
            
            let transportApiResult = TransportApiResult<Journey>()
            
            if (accessToken == nil)
            {
                transportApiResult.error = self.tokenComponent.defaultErrorResponse
                
                completion(transportApiResult)
                
                return
            }
            
            if (maxItineraries < 1 || maxItineraries > 5)
            {
                transportApiResult.error = "Invalid value for maxItineraries. Expected a value between or including 1 and 5.";
                
                completion(transportApiResult)
                
                return
            }
         
            var input = "{\"geometry\": {\"type\":" +
                           "\"Multipoint\",\"coordinates\": " +
                           "[[" + String(startLocation.longitude) + "," + String(startLocation.latitude) + "]," +
                           "[" + String(endLocation.longitude) + "," + String(endLocation.latitude) + "]]}," +
                           "\"time\": \"" + time.iso8601 + "\"," +
                           "\"timeType\": \"" + String(describing: timeType) + "\"," +
                           "\"profile\": \"" + String(describing: profile) + "\"," +
                           "\"maxItineraries\": " + String(maxItineraries) + ""
            
            if (fareProducts != nil && fareProducts.count > 0)
            {
                input += ",\"fareProducts\": [\"" + fareProducts.joined(separator: "\",\"") + "\"]"
            }
            
            // TODO This is bad and should be done with classes if possible:
            var only = ""
            var agencies = ""
            var modes = ""
            if (onlyAgencies != nil && onlyAgencies.count > 0)
            {
                agencies = "\"agencies\": [\"" + onlyAgencies.joined(separator: "\",\"") + "\"]"
            }
            
            if (onlyModes != nil && onlyModes.count > 0)
            {
                for mode in onlyModes
                {
                    modes += "\"" + mode.rawValue + "\","
                }

                modes = "\"modes\": [" + modes.removeLastCharacter() + "]"
            }
            
            if (!agencies.isEmpty)
            {
                only = "\"only\": {" + agencies
            }
            
            if (!modes.isEmpty && agencies.isEmpty)
            {
                only = "\"only\": {" + modes + "}"
            }
            else if (!modes.isEmpty && !agencies.isEmpty)
            {
                only += "," + modes + "}"
            }
            else if (!agencies.isEmpty)
            {
                only += "}"
            }
            
            if (!only.isEmpty)
            {
                input += "," + only
            }
            
            // Start more bad code. Omit:
            var omit = ""
            agencies = ""
            modes = ""
            
            if (omitAgencies != nil && omitAgencies.count > 0)
            {
                agencies = "\"agencies\": [\"" + omitAgencies.joined(separator: "\",\"") + "\"]"
            }
            
            if (omitModes != nil && omitModes.count > 0)
            {
                for mode in omitModes
                {
                    modes += "\"" + mode.rawValue + "\","
                }

                modes = "\"modes\": [" + modes.removeLastCharacter() + "]"
            }
            
            if (!agencies.isEmpty)
            {
                omit = "\"omit\": {" + agencies
            }
            
            if (!modes.isEmpty && agencies.isEmpty)
            {
                omit = "\"omit\": {" + modes + "}"
            }
            else if (!modes.isEmpty && !agencies.isEmpty)
            {
                omit += "," + modes + "}"
            }
            else if (!agencies.isEmpty)
            {
                omit += "}"
            }
            
            if (!omit.isEmpty)
            {
                input += "," + omit
            }
            
            input += "}"
            
            // End of really bad code section.
            
            let json:JSON = JSON(parseJSON: input)
            
            let path = self.platformURL + "journeys"
            
            RestApiManager.sharedInstance.makeHTTPPostRequest(path: path,
                                                              accessToken : accessToken,
                                                              json: json,
                                                              onCompletion: { json, err, response in
                                                                
                transportApiResult.httpStatusCode = response?.statusCode
                if (response?.statusCode != 201)
                {
                    transportApiResult.error = json.rawString()
                }
                else
                {
                    var journeyJson = json as JSON
                    
                    let jouneysModel = Journey.init(dictionary: (journeyJson.dictionaryObject as? NSDictionary)!)
                    
                    transportApiResult.rawJson = journeyJson.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                    transportApiResult.isSuccess = true
                    transportApiResult.Data = jouneysModel
                }
                
                completion(transportApiResult)
            })
        }
    }
    
    public func GetAgencies(onlyAgencies: [String]! = nil,
                            omitAgencies: [String]! = nil,
                            at: Date! = nil,
                            location: CLLocationCoordinate2D! = nil,
                            boundingBox: String! = nil,
                            exclude: String! = nil,
                            radiusInMeters: Int = -1,
                            limit: Int = 100,
                            offset: Int = 0,
                            completion: @escaping (_ result: TransportApiResult<[Agency]>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: String!) in
            
            let transportApiResult = TransportApiResult<[Agency]>()
            
            if (accessToken == nil)
            {
                transportApiResult.error = self.tokenComponent.defaultErrorResponse
                
                completion(transportApiResult)
                
                return
            }

            if (radiusInMeters < -1 )
            {
                transportApiResult.error = "Invalid radius. Valid values are positive numbers or -1."
                
                completion(transportApiResult)
                
                return
            }
            
            if (limit > self.maxLimit || limit < 0)
            {
                transportApiResult.error = "Invalid limit. Valid values are positive numbers up to " + String(self.maxLimit) + ".";
                
                completion(transportApiResult)
                
                return
            }
            
            if (onlyAgencies != nil && omitAgencies != nil && onlyAgencies.count > 0 && omitAgencies.count > 0)
            {
                transportApiResult.error = "Either onlyAgencies or omitAgencies can be provided. Not both.";
                
                completion(transportApiResult)
                
                return
            }
            
            if (boundingBox != nil && !boundingBox.isEmpty)
            {
                if (boundingBox.components(separatedBy: ",").count != 4)
                {
                    transportApiResult.error = "Invalid bounding box. See valid examples here: https://developer.whereismytransport.com/documentation#boundingbox";
                    
                    completion(transportApiResult)
                    
                    return
                }
            }

            let path = self.platformURL + "agencies"
            
            let query = ""
                .addOmitAgencies(omitAgencies: omitAgencies)
                .addOnlyAgencies(onlyAgencies: onlyAgencies)
                .addLocation(location: location)
                .addDateAt(at: at)
                .addBoundingBox(bbox: boundingBox)
                .addExclude(exclude: exclude)
                .addRadiusInMeters(radiusInMeters: radiusInMeters)
                .addLimit(limit: limit)
                .addOffset(offset: offset)
                .removeFirstCharacter()
        
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: accessToken,
                                                             query: query,
                                                             onCompletion: { json, err, response in
                
                transportApiResult.httpStatusCode = response?.statusCode
                if (response?.statusCode != 200)
                {
                    transportApiResult.error = json.rawString()
                }
                else
                {
                    var agenciesJson = json as JSON
                    
                    let agenciesArray = agenciesJson.arrayObject as? NSArray
                    
                    let agenciesModel = Agency.modelsFromDictionaryArray(array: agenciesArray!)
                    
                    transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                    transportApiResult.isSuccess = true
                    transportApiResult.Data = agenciesModel
                }
 
                completion(transportApiResult)
            })
        }
    }

    
}
