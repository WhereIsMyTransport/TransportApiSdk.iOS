//
//  TokenComponent.swift
//  Pods
//
//  Created by Chris on 1/24/17.
//
//

import SwiftyJSON

internal class TokenComponent
{
    public let defaultErrorResponse = "Unable to generate access token. Please check your credentials."
    
    private let identityURL = "https://identity.whereismytransport.com/connect/token/"
    private var transportApiClientSettings: TransportApiClientSettings
    private var accessToken: String!
    private var expiryDate = NSDate()
    
    public init(transportApiClientSettings: TransportApiClientSettings)
    {
        self.transportApiClientSettings = transportApiClientSettings
    }
    
    public func getAccessToken(onCompletion: @escaping (String!) -> Void) {
        // Check if we have an access token and if the expiry date has been reached.
        
        if (self.accessToken != nil && !self.accessToken.isEmpty && NSDate().timeIntervalSince1970 < self.expiryDate.timeIntervalSince1970)
        {
            onCompletion(self.accessToken)
        }
        else
        {
            // Get new access token.
            
            let clientIdEncoded = addingPercentEncodingForFormUrlencoded(input: self.transportApiClientSettings.ClientId)!
            let clientSecretEncoded = addingPercentEncodingForFormUrlencoded(input: self.transportApiClientSettings.ClientSecret)!
            
            let query = "client_id=" + clientIdEncoded +
                "&client_secret=" + clientSecretEncoded +
                "&grant_type=client_credentials&scope=transportapi%3Aall"

            RestApiManager.sharedInstance.makeHTTPPostRequest(path: identityURL, accessToken: nil, queryUrlEncoded: query, onCompletion: { json, err, response in
                var result = json as JSON
                let access_token = result["access_token"].stringValue
                let expires_in = result["expires_in"].doubleValue
                
                if !access_token.isEmpty
                {
                    self.accessToken = access_token
                    
                    // Expiry date will be the current time plus the expiry window.
                    self.expiryDate = NSDate().addingTimeInterval(expires_in)
                }
                else
                {
                    self.accessToken = nil
                }
                
                onCompletion(self.accessToken)
            })
        }
    }
    
    private func addingPercentEncodingForFormUrlencoded(input: String) -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._* ")
        
        return input.addingPercentEncoding(withAllowedCharacters: allowedCharacters)?.replacingOccurrences(of: " ", with: "+")
    }
}
