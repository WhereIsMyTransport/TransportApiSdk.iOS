//
//  RestApiManager.swift
//  Pods
//
//  Created by Chris on 1/25/17.
//
//  A lot of this code comes from here: https://devdactic.com/parse-json-with-swift/
//
//
import SwiftyJSON

typealias ServiceResponse = (JSON, NSError?, HTTPURLResponse?) -> Void

internal class RestApiManager: NSObject {
    static let sharedInstance = RestApiManager()
    
    // MARK: Perform a GET Request
    public func makeHTTPGetRequest(path: String, accessToken: String, timeout: Double, query: String, onCompletion: @escaping ServiceResponse) {
        var queryString = path
        
        if (!query.isEmpty)
        {
            queryString.append("?")
            queryString.append(query)
        }
        
        do
        {
            let request = try NSMutableURLRequest(url: NSURL(string: queryString)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
            
            let session = URLSession.shared
            
            request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            
            let task = try session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if let jsonData = data
                {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil, response as! HTTPURLResponse?)
                } else
                {
                    onCompletion(JSON.null, error as NSError?, response as! HTTPURLResponse?)
                }
            })
            task.resume()
        }
        catch
        {
            // TODO Error Stuffs
            onCompletion(JSON.null, nil, nil)
        }
    }
    
    // MARK: Perform a POST Request
    public func makeHTTPPostRequest(path: String, accessToken: String, timeout: Double, query: String?, json: JSON, onCompletion: @escaping ServiceResponse)
    {
        do
        {
            let data = try json.rawString()?.data(using: .utf8)

            try makeHTTPPostRequest(isIdsRequest: false, path: path, data: data!, timeout: timeout, accessToken: accessToken, query: query, onCompletion: { json, err, response in
                
                onCompletion(json, err, response)
            })
        }
        catch
        {
            // TODO Error Stuffs
            onCompletion(JSON.null, nil, nil)
        }
    }
    
    // MARK: Perform a POST Request
    public func makeHTTPPostRequest(path: String, timeout: Double, queryUrlEncoded: String, onCompletion: @escaping ServiceResponse)
    {
        let data = queryUrlEncoded.data(using: .utf8)!
        
        makeHTTPPostRequest(isIdsRequest: true, path: path, data: data, timeout: timeout, onCompletion: { json, err, response in

            onCompletion(json, err, response)
        })

    }
    
    public func getErrorCode(error: NSError) -> Int
    {
        if (error.code == -1001)
        {
            // Timeout
            return 504
        }
        else
        {
            // Unknown
            return 500
        }
    }
    
    public func getErrorDescription(error: NSError) -> String
    {
        return error.localizedDescription
    }
    
    private func makeHTTPPostRequest(isIdsRequest: Bool, path: String, data: Data, timeout: Double, accessToken: String? = nil, query: String? = nil, onCompletion: @escaping ServiceResponse) {
        var queryString = path
        
        if (query != nil && !query!.isEmpty)
        {
            queryString.append("?")
            queryString.append(query!)
        }
        
        let request = NSMutableURLRequest(url: NSURL(string: queryString)! as URL, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: timeout)
        
        // Set the method to POST
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if (!isIdsRequest && accessToken != nil && !(accessToken?.isEmpty)!)
        {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer " + accessToken!, forHTTPHeaderField: "Authorization")
        }
        else if (isIdsRequest)
        {
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        else
        {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        do {
            // Set the POST body for the request
            request.httpBody = data
            
            let session = URLSession.shared
            
            let task = try session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
                if let jsonData = data
                {
                    let json:JSON = JSON(data: jsonData)
                    onCompletion(json, nil, response as! HTTPURLResponse?)
                } else
                {
                    onCompletion(JSON.null, error as NSError?, response as! HTTPURLResponse?)
                }
            })
            task.resume()
        }
        catch
        {
            // TODO Error Stuffs
            onCompletion(JSON.null, nil, nil)
        }
    }
}
