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
    private let defaultErrorResponse = "Unable to generate access token. Please check your credentials."
    private let noInternetErrorResponse = "The internet connection appears to be offline."
    
    private let identityURL = "https://identity.whereismytransport.com/connect/token/"
    private var transportApiClientSettings: TransportApiClientSettings
    private var accessToken: String!
    private var expiryDate = NSDate()
    
    public init(transportApiClientSettings: TransportApiClientSettings)
    {
        self.transportApiClientSettings = transportApiClientSettings
    }
    
    public func getAccessToken(onCompletion: @escaping (AccessToken) -> Void) {
        // Check if we have an access token and if the expiry date has been reached.
        
        if (self.accessToken != nil && !self.accessToken.isEmpty && NSDate().timeIntervalSince1970 < self.expiryDate.timeIntervalSince1970)
        {
            onCompletion(AccessToken(accessToken: self.accessToken, error: nil))
        }
        else
        {
            // Get new access token.
            
            let clientIdEncoded = addingPercentEncodingForFormUrlencoded(input: self.transportApiClientSettings.clientId)!
            let clientSecretEncoded = addingPercentEncodingForFormUrlencoded(input: self.transportApiClientSettings.clientSecret)!
            
            let query = "client_id=" + clientIdEncoded +
                "&client_secret=" + clientSecretEncoded +
                "&grant_type=client_credentials&scope=transportapi%3Aall"

            RestApiManager.sharedInstance.makeHTTPPostRequest(path: identityURL, timeout: Double(self.transportApiClientSettings.timeoutInSeconds), queryUrlEncoded: query, onCompletion: { json, err, response in
                
                var accessToken: AccessToken?
                
                if (err != nil)
                {
                    if (err?.code == -1009)
                    {
                        // No internet
                        accessToken = AccessToken(accessToken: nil, error: self.noInternetErrorResponse)
                    }
                    else
                    {
                        accessToken = AccessToken(accessToken: nil, error: self.defaultErrorResponse)
                    }
                }
                else
                {
                    var result = json as JSON
                    let access_token = result["access_token"].stringValue
                    let expires_in = result["expires_in"].doubleValue
                    
                    if !access_token.isEmpty
                    {
                        self.accessToken = access_token
                        accessToken = AccessToken(accessToken: access_token, error: nil)
                        
                        // Expiry date will be the current time plus the expiry window.
                        self.expiryDate = NSDate().addingTimeInterval(expires_in)
                    }
                    else
                    {
                        self.accessToken = nil
                        
                        accessToken = AccessToken(accessToken: nil, error: self.defaultErrorResponse)
                    }
                }
                
                onCompletion(accessToken!)
            })
        }
    }
    
    private func addingPercentEncodingForFormUrlencoded(input: String) -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._* ")
        
        return input.addingPercentEncoding(withAllowedCharacters: allowedCharacters)?.replacingOccurrences(of: " ", with: "+")
    }
}
