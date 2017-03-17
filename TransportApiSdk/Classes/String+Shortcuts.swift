//
//  QueryString+Shortcuts.swift
//  Pods
//
//  Created by Chris on 1/28/17.
//
//

import Foundation
import CoreLocation

extension String {
    
    func removeFirstCharacter() -> String {
        if (!self.isEmpty)
        {
            var str = self
            
            str.remove(at: str.startIndex)
            
            return str
        }
        
        return self
    }
    
    func removeLastCharacter() -> String {
        if (!self.isEmpty)
        {
            var str = self
            
            str.remove(at: str.index(before: str.endIndex))
            
            return str
        }
        
        return self
    }
    
    func addLocation(location: CLLocationCoordinate2D?) -> String {
        if (location != nil)
        {
            return self + "&point=" + String(location!.latitude) + "," + String(location!.longitude)
        }
        
        return self
    }
    
    func addDateAt(at: Date?) -> String {
        if (at != nil)
        {
            return self + "&at=" + at!.iso8601
        }
        
        return self
    }
    
    func addRadiusInMeters(radiusInMeters: Int) -> String {
        if (radiusInMeters > 0)
        {
            return self + "&radius=" + String(radiusInMeters)
        }
        
        return self
    }
    
    func addOffset(offset: Int) -> String {
        if (offset > 0)
        {
            return self + "&offset=" + String(offset)
        }
        
        return self
    }
    
    func addLimit(limit: Int) -> String {
        if (limit != 100)
        {
            return self + "&limit=" + String(limit)
        }
        
        return self
    }
    
    func addString(parameterName: String, value: String?) -> String {
        if (value != nil)
        {
            return self + "&" + parameterName + "=" + value!
        }
        
        return self
    }
    
    func addOnlyAgencies(onlyAgencies: [String]?) -> String {
        if (onlyAgencies != nil)
        {
            return self + "&agencies=" + onlyAgencies!.joined(separator: ",")
        }
        
        return self
    }
    
    func addOmitAgencies(omitAgencies: [String]?) -> String {
        if (omitAgencies != nil)
        {
            return self + "&agencies=~" + omitAgencies!.joined(separator: ",~")
        }
        
        return self
    }
    
    func addServesLines(servesLines: [String]?) -> String {
        if (servesLines != nil)
        {
            return self + "&servesLines=" + servesLines!.joined(separator: ",~")
        }
        
        return self
    }
    
    func addServesStops(servesStops: [String]?) -> String {
        if (servesStops != nil)
        {
            return self + "&servesStops=" + servesStops!.joined(separator: ",~")
        }
        
        return self
    }
    
    func addShowChildren(showChildren: Bool) -> String {
        if (showChildren)
        {
            return self + "&showChildren=true"
        }
        else
        {
            return self + "&showChildren=false"
        }
    }
    
    func addLimitModes(limitModes: [String]?) -> String {
        if (limitModes != nil)
        {
            var limitedModes = ""
            
            for mode in limitModes!
            {
                limitedModes = limitedModes + mode + ","
            }
            
            return self + "&modes=" + limitedModes.removeLastCharacter()
        }
        
        return self
    }
    
    func addBoundingBox(bbox: String?) -> String {
        if (bbox != nil && !bbox!.isEmpty)
        {
            return self + "&bbox=" + bbox!
        }
        
        return self
    }
    
    func addExclude(exclude: String?) -> String {
        if (exclude != nil && !exclude!.isEmpty)
        {
            return self + "&exclude=" + exclude!
        }
        
        return self
    }
    
    func addDate(parameterName: String, date: Date?) -> String {
        if (date != nil)
        {
            return self + "&" + parameterName + "=" + date!.iso8601
        }
        
        return self
    }
    
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}
