/*
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Leg {
	public var distance : Distance?
	public var geometry : Geometry?
	public var href : String?
	public var duration : Int?
	public var type : String?
	public var waypoints : Array<Waypoint>?
	public var directions : Array<Direction>?
    public var line : Line?
    public var fare : Fare?
    public var vehicle : Vehicle?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let legs_list = Legs.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of Legs Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [Leg]
    {
        var models:[Leg] = []
        for item in array
        {
            models.append(Leg(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let legs = Legs(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Legs Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if (dictionary["distance"] != nil) { distance = Distance(dictionary: dictionary["distance"] as! NSDictionary) }
		if (dictionary["geometry"] != nil) { geometry = Geometry(dictionary: dictionary["geometry"] as! NSDictionary) }
		href = dictionary["href"] as? String
		duration = dictionary["duration"] as? Int
		type = dictionary["type"] as? String
		if (dictionary["waypoints"] != nil) { waypoints = Waypoint.modelsFromDictionaryArray(array: dictionary["waypoints"] as! NSArray) }
		if (dictionary["directions"] != nil) { directions = Direction.modelsFromDictionaryArray(array: dictionary["directions"] as! NSArray) }
        if (dictionary["line"] != nil) { line = Line(dictionary: dictionary["line"] as! NSDictionary) }
        if (dictionary["fare"] != nil) { fare = Fare(dictionary: dictionary["fare"] as! NSDictionary) }
        if (dictionary["vehicle"] != nil) { vehicle = Vehicle(dictionary: dictionary["vehicle"] as! NSDictionary) }
    }

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.distance?.dictionaryRepresentation(), forKey: "distance")
		dictionary.setValue(self.geometry?.dictionaryRepresentation(), forKey: "geometry")
		dictionary.setValue(self.href, forKey: "href")
		dictionary.setValue(self.duration, forKey: "duration")
		dictionary.setValue(self.type, forKey: "type")
        dictionary.setValue(self.line?.dictionaryRepresentation(), forKey: "line")
        dictionary.setValue(self.fare?.dictionaryRepresentation(), forKey: "fare")
        dictionary.setValue(self.vehicle?.dictionaryRepresentation(), forKey: "vehicle")

		return dictionary
	}

}
