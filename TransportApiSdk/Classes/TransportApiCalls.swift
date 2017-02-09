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
            
            let path = self.platformURL + "agencies/" + id
            
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path,
                                                             accessToken: accessToken,
                                                             query: "",
                                                             onCompletion: { json, err, response in
                                                                
                                                                transportApiResult.httpStatusCode = response?.statusCode
                                                                if (response?.statusCode != 200)
                                                                {
                                                                    transportApiResult.error = json.rawString()
                                                                }
                                                                else
                                                                {
                                                                    var agenciesJson = json as JSON
                                                                    
                                                                    let agenciesDict = agenciesJson.dictionary as? NSDictionary
                                                                    
                                                                    let agenciesModel = Agency.init(dictionary: agenciesDict!)
                                                                    
                                                                    transportApiResult.rawJson = json.rawString(options: JSONSerialization.WritingOptions.prettyPrinted)
                                                                    transportApiResult.isSuccess = true
                                                                    transportApiResult.Data = agenciesModel
                                                                }
                                                                
                                                                completion(transportApiResult)
            })
        }
    }

    
}
