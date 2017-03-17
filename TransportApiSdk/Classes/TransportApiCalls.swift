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
                           transportApiClientSettings: TransportApiClientSettings,
                           fareProducts: [String]! = nil,
                           onlyAgencies: [String]! = nil,
                           omitAgencies: [String]! = nil,
                           onlyModes: [String]! = nil,
                           omitModes: [String]! = nil,
                           exclude: String! = nil,
                           startLocation: CLLocationCoordinate2D,
                           endLocation: CLLocationCoordinate2D,
                           time: Date = Date(),
                           timeType: String = "DepartAfter",
                           profile: String = "ClosestToTime",
                           maxItineraries: Int = 3,
                           completion: @escaping (_ result: TransportApiResult<Journey>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<Journey>()
            
            if (accessToken.accessToken == nil)
            {
                transportApiResult.error = accessToken.error
                
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
                    modes += "\"" + mode + "\","
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
                    modes += "\"" + mode + "\","
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
                                                              accessToken : accessToken.accessToken,
                                                              timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                              query: query,
                                                              json: json,
                                                              onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
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
                                                                        transportApiResult.data = jouneysModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetJourney(tokenComponent: TokenComponent,
                          transportApiClientSettings: TransportApiClientSettings,
                         id: String,
                         exclude: String! = nil,
                         completion: @escaping (_ result: TransportApiResult<Journey>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<Journey>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "JourneyId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
                .removeFirstCharacter()
            
            let path = self.platformURL + "journeys/" + id
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
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
                                                                        transportApiResult.data = jouneysModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetItinerary(
      tokenComponent: TokenComponent,
      transportApiClientSettings: TransportApiClientSettings,
      journeyId: String,
      itineraryId: String,
      exclude: String! = nil,
      completion: @escaping (_ result: TransportApiResult<Itinerary>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<Itinerary>()
            
            if (journeyId.isEmpty)
            {
                transportApiResult.error = "JourneyId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            if (itineraryId.isEmpty)
            {
                transportApiResult.error = "ItineraryId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
                .removeFirstCharacter()
            
            let path = self.platformURL + "journeys/" + journeyId + "/itineraries/" + itineraryId
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
                                                                    transportApiResult.httpStatusCode = response?.statusCode
                                                                    if (response?.statusCode != 200)
                                                                    {
                                                                        transportApiResult.error = json.rawString()
                                                                    }
                                                                    else
                                                                    {
                                                                        let itineraryJson = json as JSON
                                                                        
                                                                        let itineraryModel = Itinerary.init(dictionary: NSDictionary(dictionary: itineraryJson.dictionaryObject!))
                                                                        
                                                                        transportApiResult.rawJson = itineraryJson.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                        transportApiResult.isSuccess = true
                                                                        transportApiResult.data = itineraryModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }

    class func GetAgencies(tokenComponent: TokenComponent,
                           transportApiClientSettings: TransportApiClientSettings,
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
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<[Agency]>()
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
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
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
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
                                                                        transportApiResult.data = agenciesModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetAgency(tokenComponent: TokenComponent,
        transportApiClientSettings: TransportApiClientSettings,
        id: String,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<Agency>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<Agency>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "AgencyId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
                .removeFirstCharacter()
            
            let path = self.platformURL + "agencies/" + id
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
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
                                                                        transportApiResult.data = agencyModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetStops(tokenComponent: TokenComponent,
                        transportApiClientSettings: TransportApiClientSettings,
                           onlyAgencies: [String]! = nil,
                           omitAgencies: [String]! = nil,
                           limitModes: [String]! = nil,
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
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<[Stop]>()
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
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
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
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
                                                                        transportApiResult.data = stopsModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetStop(tokenComponent: TokenComponent,
                       transportApiClientSettings: TransportApiClientSettings,
                         id: String,
                         exclude: String! = nil,
                         completion: @escaping (_ result: TransportApiResult<Stop>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<Stop>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "StopId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
                .removeFirstCharacter()
            
            let path = self.platformURL + "stops/" + id
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
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
                                                                        transportApiResult.data = stopModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }

    class func GetLines(tokenComponent: TokenComponent,
                        transportApiClientSettings: TransportApiClientSettings,
                        onlyAgencies: [String]! = nil,
                        omitAgencies: [String]! = nil,
                        limitModes: [String]! = nil,
                        servesStops: [String]! = nil,
                        location: CLLocationCoordinate2D! = nil,
                        boundingBox: String! = nil,
                        exclude: String! = nil,
                        radiusInMeters: Int = -1,
                        limit: Int = 100,
                        offset: Int = 0,
                        completion: @escaping (_ result: TransportApiResult<[Line]>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<[Line]>()
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
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
            
            let path = self.platformURL + "lines"
            
            let query = ""
                .addOmitAgencies(omitAgencies: omitAgencies)
                .addOnlyAgencies(onlyAgencies: onlyAgencies)
                .addLimitModes(limitModes: limitModes)
                .addServesStops(servesStops: servesStops)
                .addLocation(location: location)
                .addBoundingBox(bbox: boundingBox)
                .addExclude(exclude: exclude)
                .addRadiusInMeters(radiusInMeters: radiusInMeters)
                .addLimit(limit: limit)
                .addOffset(offset: offset)
                .removeFirstCharacter()
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
                                                                    transportApiResult.httpStatusCode = response?.statusCode
                                                                    if (response?.statusCode != 200)
                                                                    {
                                                                        transportApiResult.error = json.rawString()
                                                                    }
                                                                    else
                                                                    {
                                                                        let linesJson = json as JSON
                                                                        
                                                                        let linesArray = linesJson.arrayObject as! NSArray
                                                                        
                                                                        let linesModel = Line.modelsFromDictionaryArray(array: linesArray)
                                                                        
                                                                        transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                        transportApiResult.isSuccess = true
                                                                        transportApiResult.data = linesModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }

    class func GetLine(tokenComponent: TokenComponent,
                       transportApiClientSettings: TransportApiClientSettings,
                       id: String,
                       exclude: String! = nil,
                       completion: @escaping (_ result: TransportApiResult<Line>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<Line>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "LineId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
                .removeFirstCharacter()
            
            let path = self.platformURL + "lines/" + id
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
                                                                    transportApiResult.httpStatusCode = response?.statusCode
                                                                    if (response?.statusCode != 200)
                                                                    {
                                                                        transportApiResult.error = json.rawString()
                                                                    }
                                                                    else
                                                                    {
                                                                        let lineJson = json as JSON
                                                                        
                                                                        let lineDict = lineJson.dictionaryObject as! NSDictionary
                                                                        
                                                                        let lineModel = Line.init(dictionary: lineDict)
                                                                        
                                                                        transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                        transportApiResult.isSuccess = true
                                                                        transportApiResult.data = lineModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }

    class func GetFareProducts(tokenComponent: TokenComponent,
                               transportApiClientSettings: TransportApiClientSettings,
                        onlyAgencies: [String]! = nil,
                        omitAgencies: [String]! = nil,
                        exclude: String! = nil,
                        limit: Int = 100,
                        offset: Int = 0,
                        completion: @escaping (_ result: TransportApiResult<[FareProduct]>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<[FareProduct]>()
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
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
            
            let path = self.platformURL + "fareproducts"
            
            let query = ""
                .addOmitAgencies(omitAgencies: omitAgencies)
                .addOnlyAgencies(onlyAgencies: onlyAgencies)
                .addExclude(exclude: exclude)
                .addLimit(limit: limit)
                .addOffset(offset: offset)
                .removeFirstCharacter()
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
                                                                    transportApiResult.httpStatusCode = response?.statusCode
                                                                    if (response?.statusCode != 200)
                                                                    {
                                                                        transportApiResult.error = json.rawString()
                                                                    }
                                                                    else
                                                                    {
                                                                        let fareProductsJson = json as JSON
                                                                        
                                                                        let fareProductsArray = fareProductsJson.arrayObject as! NSArray
                                                                        
                                                                        let fareProductsModel = FareProduct.modelsFromDictionaryArray(array: fareProductsArray)
                                                                        
                                                                        transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                        transportApiResult.isSuccess = true
                                                                        transportApiResult.data = fareProductsModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }

    class func GetFareProduct(tokenComponent: TokenComponent,
                              transportApiClientSettings: TransportApiClientSettings,
                       id: String,
                       exclude: String! = nil,
                       completion: @escaping (_ result: TransportApiResult<FareProduct>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<FareProduct>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "FareProductId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
                .removeFirstCharacter()
            
            let path = self.platformURL + "fareproducts/" + id
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
                                                                    transportApiResult.httpStatusCode = response?.statusCode
                                                                    if (response?.statusCode != 200)
                                                                    {
                                                                        transportApiResult.error = json.rawString()
                                                                    }
                                                                    else
                                                                    {
                                                                        let fareProductJson = json as JSON
                                                                        
                                                                        let fareProductDict = fareProductJson.dictionaryObject as! NSDictionary
                                                                        
                                                                        let fareProductModel = FareProduct.init(dictionary: fareProductDict)
                                                                        
                                                                        transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                        transportApiResult.isSuccess = true
                                                                        transportApiResult.data = fareProductModel
                                                                }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }
    
    class func GetStopTimetable(
        tokenComponent: TokenComponent,
        transportApiClientSettings: TransportApiClientSettings,
        id: String,
        earliestArrivalTime: Date! = nil,
        latestArrivalTime: Date! = nil,
        limit: Int = 100,
        offset: Int = 0,
        exclude: String! = nil,
        completion: @escaping (_ result: TransportApiResult<[StopTimetable]>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<[StopTimetable]>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "StopId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addExclude(exclude: exclude)
                .addDate(parameterName: "earliestArrivalTime", date: earliestArrivalTime)
                .addDate(parameterName: "latestArrivalTime", date: latestArrivalTime)
                .addLimit(limit: limit)
                .addOffset(offset: offset)
                .removeFirstCharacter()
            
            let path = self.platformURL + "stops/" + id + "/timetables"
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
                                                                    transportApiResult.httpStatusCode = response?.statusCode
                                                                    if (response?.statusCode != 200)
                                                                    {
                                                                        transportApiResult.error = json.rawString()
                                                                    }
                                                                    else
                                                                    {
                                                                        let stopTimetableJson = json as JSON
                                                                        
                                                                        let stopTimetableArray = stopTimetableJson.arrayObject as! NSArray
                                                                        
                                                                        let stopTimetableModel = StopTimetable.modelsFromDictionaryArray(array: stopTimetableArray)

                                                                        transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                        transportApiResult.isSuccess = true
                                                                        transportApiResult.data = stopTimetableModel
                                                                    }
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }

    class func GetLineTimetable(tokenComponent: TokenComponent,
                                transportApiClientSettings: TransportApiClientSettings,
                                id: String,
                                departureStopIdFilter: String! = nil,
                                arrivalStopIdFilter: String! = nil,
                                earliestDepartureTime: Date! = nil,
                                latestDepartureTime: Date! = nil,
                                limit: Int = 100,
                                offset: Int = 0,
                                exclude: String! = nil,
                                completion: @escaping (_ result: TransportApiResult<[LineTimetable]>) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: AccessToken) in
            
            let transportApiResult = TransportApiResult<[LineTimetable]>()
            
            if (id.isEmpty)
            {
                transportApiResult.error = "LineId is required."
                
                completion(transportApiResult)
                
                return
            }
            
            guard let token = accessToken.accessToken else {
                transportApiResult.error = accessToken.error
                
                completion(transportApiResult)
                
                return
            }
            
            let query = ""
                .addDate(parameterName: "earliestDepartureTime", date: earliestDepartureTime)
                .addDate(parameterName: "latestDepartureTime", date: latestDepartureTime)
                .addString(parameterName: "departureStopIdFilter", value: departureStopIdFilter)
                .addString(parameterName: "arrivalStopIdFilter", value: arrivalStopIdFilter)
                .addExclude(exclude: exclude)
                .addLimit(limit: limit)
                .addOffset(offset: offset)
                .removeFirstCharacter()
            
            let path = self.platformURL + "lines/" + id + "/timetables"
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: token,
                                                             timeout: Double(transportApiClientSettings.timeoutInSeconds),
                                                             query: query,
                                                             onCompletion: { json, err, response in
                                                                
                                                                if (err != nil)
                                                                {
                                                                    transportApiResult.httpStatusCode = RestApiManager.sharedInstance.getErrorCode(error: err!)
                                                                    transportApiResult.error = RestApiManager.sharedInstance.getErrorDescription(error: err!)
                                                                    transportApiResult.isSuccess = false
                                                                }
                                                                else
                                                                {
                                                                    transportApiResult.httpStatusCode = response?.statusCode
                                                                    if (response?.statusCode != 200)
                                                                    {
                                                                        transportApiResult.error = json.rawString()
                                                                    }
                                                                    else
                                                                    {
                                                                        let lineTimetableJson = json as JSON
                                                                        
                                                                        let lineTimetableArray = lineTimetableJson.arrayObject as! NSArray
                                                                        
                                                                        let lineTimetableModel = LineTimetable.modelsFromDictionaryArray(array: lineTimetableArray)
                                                                        
                                                                        transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                        transportApiResult.isSuccess = true
                                                                        transportApiResult.data = lineTimetableModel
                                                                    }
                                                                }
                                                                completion(transportApiResult)
            })
        }
    }
}
