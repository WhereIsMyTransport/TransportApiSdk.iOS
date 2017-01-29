/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class Journey {
	public var geometry : Geometry?
	public var href : String?
	public var id : String?
	public var timeType : String?
	public var only : Only?
	public var fareProducts : Array<String>?
	public var itineraries : Array<Itineraries>?
	public var omit : Omit?
	public var time : String?
	public var maxItineraries : Int?
	public var profile : String?

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let journey = Journey(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: Json4Swift_Base Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if (dictionary["geometry"] != nil) { geometry = Geometry(dictionary: dictionary["geometry"] as! NSDictionary) }
		href = dictionary["href"] as? String
		id = dictionary["id"] as? String
		timeType = dictionary["timeType"] as? String
		if (dictionary["only"] != nil) { only = Only(dictionary: dictionary["only"] as! NSDictionary) }
		if (dictionary["fareProducts"] != nil) { fareProducts = dictionary["fareProducts"] as! Array<String>? }
		if (dictionary["itineraries"] != nil) { itineraries = Itineraries.modelsFromDictionaryArray(array: dictionary["itineraries"] as! NSArray) }
		if (dictionary["omit"] != nil) { omit = Omit(dictionary: dictionary["omit"] as! NSDictionary) }
		time = dictionary["time"] as? String
		maxItineraries = dictionary["maxItineraries"] as? Int
		profile = dictionary["profile"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.geometry?.dictionaryRepresentation(), forKey: "geometry")
		dictionary.setValue(self.href, forKey: "href")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.timeType, forKey: "timeType")
		dictionary.setValue(self.only?.dictionaryRepresentation(), forKey: "only")
		dictionary.setValue(self.omit?.dictionaryRepresentation(), forKey: "omit")
		dictionary.setValue(self.time, forKey: "time")
		dictionary.setValue(self.maxItineraries, forKey: "maxItineraries")
		dictionary.setValue(self.profile, forKey: "profile")

		return dictionary
	}

}
