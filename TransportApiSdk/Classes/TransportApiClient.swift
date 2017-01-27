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
    private let platformURL = "https://platform.whereismytransport.com/api/"
    
    private var transportApiClientSettings: TransportApiClientSettings
    private var tokenComponent: TokenComponent!
    
    public init(transportApiClientSettings: TransportApiClientSettings)
    {
        self.transportApiClientSettings = transportApiClientSettings
        self.tokenComponent = TokenComponent(transportApiClientSettings: transportApiClientSettings)
    }
    
    public func PostJourney(completion: @escaping (_ result: String) -> Void)
    {
        tokenComponent.getAccessToken{
            (result: String) in
            completion("got back: \(result)")
        }
    }
    
    public func GetAgencies(limitAgencies: [String]! = nil,
                            excludeAgencies: [String]! = nil,
                            at: Date! = nil,
                            location: CLLocationCoordinate2D! = nil,
                            radiusInMeters: Int = -1,
                            limit: Int = 100,
                            offset: Int = 0,
                            completion: @escaping (_ agencies: [Agency]) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: String) in
            
            let path = self.platformURL + "agencies"
            
            var query = ""
            
            // TODO Check for errors.
            
            if (location != nil)
            {
                query += "&point=" + String(location.latitude) + "," + String(location.longitude)
            }
            
            if (at != nil)
            {
                query += "&at=" + at.iso8601
            }
            
            if (radiusInMeters > 0)
            {
                query += "&radius=" + String(radiusInMeters)
            }
            
            if (limit != 100)
            {
                query += "&limit=" + String(limit)
            }
            
            if (offset > 0)
            {
                query += "&offset=" + String(offset)
            }
            
            if (!query.isEmpty)
            {
                query.remove(at: query.startIndex)
            }
        
            RestApiManager.sharedInstance.makeHTTPGetRequest(path: path, accessToken: accessToken, query: query, onCompletion: { json, err in
                
                var agenciesJson = json as JSON
                    
                var agenciesArray = agenciesJson.arrayObject as? NSArray
                    
                var agenciesModel = Agency.modelsFromDictionaryArray(array: agenciesArray!)
                    
                completion(agenciesModel)
            })
        }
    }

    
}
