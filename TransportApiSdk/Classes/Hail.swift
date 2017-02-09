//
//  Hail.swift
//  Pods
//
//  Created by Chris on 2/8/17.
//
//

import Foundation

public class Hail
{
    public var geometry : Geometry?
    
    public class func modelsFromDictionaryArray(array:NSArray) -> [Hail]
    {
        var models:[Hail] = []
        for item in array
        {
            models.append(Hail(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["geometry"] != nil) { geometry = Geometry(dictionary: dictionary["geometry"] as! NSDictionary) }
    }
    
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.geometry?.dictionaryRepresentation(), forKey: "geometry")
        
        return dictionary
    }
}
