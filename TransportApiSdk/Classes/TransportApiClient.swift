//
//  TransportApi.swift
//  Pods
//
//  Created by Chris on 1/24/17.
//
//

import SwiftyJSON

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
    
    public func GetAgencies(completion: @escaping (_ agencies: [Agency]) -> Void)
    {
        tokenComponent.getAccessToken{
            (accessToken: String) in
            
                let path = self.platformURL + "agencies"
        
                RestApiManager.sharedInstance.makeHTTPGetRequest(path: path, accessToken: accessToken, query: "", onCompletion: { json, err in
                
                    var agenciesJson = json as JSON
                    
                    var agenciesArray = agenciesJson.arrayObject as? NSArray
                    
                    var agenciesModel = Agency.modelsFromDictionaryArray(array: agenciesArray!)
                    
                    completion(agenciesModel)
            })
        }
    }

    
}
