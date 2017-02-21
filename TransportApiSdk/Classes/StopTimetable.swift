/*
 Copyright (c) 2017 Swift Models Generated from JSON powered by http://www.json4swift.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

/* For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar */

public class StopTimetable {
    public var vehicle : Vehicle?
    public var line : Line?
    public var departureTime : String?
    public var arrivalTime : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let json4Swift_Base_list = StopTimetable.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of StopTimetable Instances.
     */
    public class func modelsFromDictionaryArray(array:NSArray) -> [StopTimetable]
    {
        var models:[StopTimetable] = []
        for item in array
        {
            models.append(StopTimetable(dictionary: item as! NSDictionary)!)
        }
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let json4Swift_Base = StopTimetable(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: StopTimetable Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        if (dictionary["vehicle"] != nil) { vehicle = Vehicle(dictionary: dictionary["vehicle"] as! NSDictionary) }
        if (dictionary["line"] != nil) { line = Line(dictionary: dictionary["line"] as! NSDictionary) }
        departureTime = dictionary["departureTime"] as? String
        arrivalTime = dictionary["arrivalTime"] as? String
    }
    
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(self.vehicle?.dictionaryRepresentation(), forKey: "vehicle")
        dictionary.setValue(self.line?.dictionaryRepresentation(), forKey: "line")
        dictionary.setValue(self.departureTime, forKey: "departureTime")
        dictionary.setValue(self.arrivalTime, forKey: "arrivalTime")
        
        return dictionary
    }
    
}
