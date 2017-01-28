/* 
Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
 
/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class ParentStop {
	public var agency : Agency?
	//public var alerts : Array<String>?
	public var modes : Array<String>?
	public var id : String?
	public var code : String?
	public var geometry : Geometry?
	public var href : String?
	public var name : String?

/**
    Returns an array of models based on given dictionary.
    
    Sample usage:
    let parentStop_list = ParentStop.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

    - parameter array:  NSArray from JSON dictionary.

    - returns: Array of ParentStop Instances.
*/
    public class func modelsFromDictionaryArray(array:NSArray) -> [ParentStop]
    {
        var models:[ParentStop] = []
        for item in array
        {
            models.append(ParentStop(dictionary: item as! NSDictionary)!)
        }
        return models
    }

/**
    Constructs the object based on the given dictionary.
    
    Sample usage:
    let parentStop = ParentStop(someDictionaryFromJSON)

    - parameter dictionary:  NSDictionary from JSON.

    - returns: ParentStop Instance.
*/
	required public init?(dictionary: NSDictionary) {

		if (dictionary["agency"] != nil) { agency = Agency(dictionary: dictionary["agency"] as! NSDictionary) }
		//if (dictionary["alerts"] != nil) { alerts = Alerts.modelsFromDictionaryArray(dictionary["alerts"] as! NSArray) }
		if (dictionary["modes"] != nil) { modes = dictionary["modes"] as! Array<String>? }
		id = dictionary["id"] as? String
		code = dictionary["code"] as? String
		if (dictionary["geometry"] != nil) { geometry = Geometry(dictionary: dictionary["geometry"] as! NSDictionary) }
		href = dictionary["href"] as? String
		name = dictionary["name"] as? String
	}

		
/**
    Returns the dictionary representation for the current instance.
    
    - returns: NSDictionary.
*/
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.agency?.dictionaryRepresentation(), forKey: "agency")
		dictionary.setValue(self.id, forKey: "id")
		dictionary.setValue(self.code, forKey: "code")
		dictionary.setValue(self.geometry?.dictionaryRepresentation(), forKey: "geometry")
		dictionary.setValue(self.href, forKey: "href")
		dictionary.setValue(self.name, forKey: "name")

		return dictionary
	}

}
