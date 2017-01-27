//
//  TransportApiClientSettings.swift
//  Pods
//
//  Created by Bilo on 1/24/17.
//
//

import Foundation

public class TransportApiClientSettings
{
    public private(set) var ClientId: String!
    public private(set) var ClientSecret: String!
    public private(set) var TimeoutInSeconds = 30
    
    public init(clientId: String, clientSecret: String){
        self.ClientId = clientId
        self.ClientSecret = clientSecret
    }
    
    public convenience init(clientId: String, clientSecret: String, timeoutInSeconds: Int)
    {
        self.init(clientId: clientId, clientSecret: clientSecret)
        self.TimeoutInSeconds = timeoutInSeconds
    }
}
