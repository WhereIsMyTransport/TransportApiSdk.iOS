/*
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Itineraries {
	public var departureTime : String?
	public var id : String?
	public var arrivalTime : String?
	public var distance : Distance?
	public var href : String?
	public var duration : Int?
	public var legs : Array<Legs>?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let itineraries_list = Itineraries.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Itineraries Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Itineraries]
    {
        var models:[Itineraries] = []
        for item in array
        {
            models.append(Itineraries(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let itineraries = Itineraries(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Itineraries Instance.
*/
	required public init?(dictionary: NSDictionary) {

		departureTime = dictionary["departureTime"] as? String
		id = dictionary["id"] as? String
		arrivalTime = dictionary["arrivalTime"] as? String
		if (dictionary["distance"] != nil) { distance = Distance(dictionary: dictionary["distance"] as! NSDictionary) }
		href = dictionary["href"] as? String
		duration = dictionary["duration"] as? Int
		if (dictionary["legs"] != nil) { legs = Legs.modelsFromDictionaryArray(array: dictionary["legs"] as! NSArray) }
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.departureTime, forKey: "departureTime")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.arrivalTime, forKey: "arrivalTime")
		dictionary.setValue(self.distance?.dictionaryRepresentation(), forKey: "distance")
		dictionary.setValue(self.href, forKey: "href")
		dictionary.setValue(self.duration, forKey: "duration")

		return dictionary
	}

}
