//
//  TransportApiCalls.swift
//  Pods
//
//  Created by Chris on 2/7/17.
//
//

import Foundation
import SwiftyJSON
import CoreLocation

internal class TransportApiCalls
{
    private static let maxLimit = 100
    private static let platformURL = "https://platform.whereismytransport.com/api/"
    
    class func PostJourney(tokenComponent: TokenComponent,
                           fareProducts: [String]! = nil,
                           onlyAgencies: [String]! = nil,
                           omitAgencies: [String]! = nil,
                           onlyModes: [TransportMode]! = nil,
                           omitModes: [TransportMode]! = nil,
                           exclude: String! = nil,
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
                transportApiResult.error = tokenComponent.defaultErrorResponse
                
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
            
            let query = ""
                .addExclude(exclude: exclude)
                .removeFirstCharacter()
            
            RestApiManager.sharedInstance.makeHTTPPostRequest(path: path,
                                                              accessToken : accessToken,
                                                              query: query,
                                                              json: json,
                                                              onCompletion: { json, err, response in
                                                                
                                                                transportApiResult.httpStatusCode = response?.statusCode
                                                                if (response?.statusCode != 201)
                                                                {
                                                                    transportApiResult.error = json.rawString()
                                                                }
                                                                else
                                                                {
                                                                    let journeyJson = json as JSON
                                                                    
                                                                    let jouneysModel = Journey.init(dictionary: NSDictionary(dictionary: journeyJson.dictionaryObject!))
                                                                    
                                                                    transportApiResult.rawJson = journeyJson.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                    transportApiResult.isSuccess = true
                                                                    transportApiResult.Data = jouneysModel
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetJourney(tokenComponent: TokenComponent,
                         id: String,
                         exclude: String! = nil,
                         completion: @escaping (_ result: TransportApiResult<Journey>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: String!) in
            
            let transportApiResult = TransportApiResult<Journey>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "JourneyId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            if (accessToken == nil)
            {
                transportApiResult.error = tokenComponent.defaultErrorResponse
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
            
            let path = self.platformURL + "journeys/" + id
            
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
                                                                    let journeyJson = json as JSON
                                                                    
                                                                    let jouneysModel = Journey.init(dictionary: NSDictionary(dictionary: journeyJson.dictionaryObject!))
                                                                    
                                                                    transportApiResult.rawJson = journeyJson.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                    transportApiResult.isSuccess = true
                                                                    transportApiResult.Data = jouneysModel
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }

    class func GetAgencies(tokenComponent: TokenComponent,
                            onlyAgencies: [String]! = nil,
                            omitAgencies: [String]! = nil,
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
                transportApiResult.error = tokenComponent.defaultErrorResponse
                
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
                                                                    let agenciesJson = json as JSON
                                                                    
                                                                    let agenciesArray = agenciesJson.arrayObject as! NSArray
                                                                    
                                                                    let agenciesModel = Agency.modelsFromDictionaryArray(array: agenciesArray)
                                                                    
                                                                    transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                    transportApiResult.isSuccess = true
                                                                    transportApiResult.Data = agenciesModel
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetAgency(tokenComponent: TokenComponent,
        id: String,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<Agency>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: String!) in
            
            let transportApiResult = TransportApiResult<Agency>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "AgencyId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            if (accessToken == nil)
            {
                transportApiResult.error = tokenComponent.defaultErrorResponse
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
            
            let path = self.platformURL + "agencies/" + id
            
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
                                                                    let agencyJson = json as JSON
                                    
                                                                    let agencyDict = agencyJson.dictionaryObject as! NSDictionary
                                                                   
                                                                    let agencyModel = Agency(dictionary: agencyDict)
                                                                    
                                                                    transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                    transportApiResult.isSuccess = true
                                                                    transportApiResult.Data = agencyModel
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetStops(tokenComponent: TokenComponent,
                           onlyAgencies: [String]! = nil,
                           omitAgencies: [String]! = nil,
                           limitModes: [TransportMode]! = nil,
                           servesLines: [String]! = nil,
                           showChildren: Bool = false,
                           location: CLLocationCoordinate2D! = nil,
                           boundingBox: String! = nil,
                           exclude: String! = nil,
                           radiusInMeters: Int = -1,
                           limit: Int = 100,
                           offset: Int = 0,
                           completion: @escaping (_ result: TransportApiResult<[Stop]>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: String!) in
            
            let transportApiResult = TransportApiResult<[Stop]>()
            
            if (accessToken == nil)
            {
                transportApiResult.error = tokenComponent.defaultErrorResponse
                
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
            
            let path = self.platformURL + "stops"
            
            let query = ""
                .addOmitAgencies(omitAgencies: omitAgencies)
                .addOnlyAgencies(onlyAgencies: onlyAgencies)
                .addLimitModes(limitModes: limitModes)
                .addServesLines(servesLines: servesLines)
                .addShowChildren(showChildren: showChildren)
                .addLocation(location: location)
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
                                                                    let stopsJson = json as JSON
                                                                    
                                                                    let stopsArray = stopsJson.arrayObject as! NSArray
                                                                    
                                                                    let stopsModel = Stop.modelsFromDictionaryArray(array: stopsArray)
                                                                    
                                                                    transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                    transportApiResult.isSuccess = true
                                                                    transportApiResult.Data = stopsModel
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetStop(tokenComponent: TokenComponent,
                         id: String,
                         exclude: String! = nil,
                         completion: @escaping (_ result: TransportApiResult<Stop>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: String!) in
            
            let transportApiResult = TransportApiResult<Stop>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "StopId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            if (accessToken == nil)
            {
                transportApiResult.error = tokenComponent.defaultErrorResponse
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
            
            let path = self.platformURL + "stops/" + id
            
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
                                                                    let stopJson = json as JSON
                                                                    
                                                                    let stopDict = stopJson.dictionaryObject as! NSDictionary
                                                                    
                                                                    let stopModel = Stop.init(dictionary: stopDict)
                                                                    
                                                                    transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                    transportApiResult.isSuccess = true
                                                                    transportApiResult.Data = stopModel
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }

    
}
